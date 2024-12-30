import { webSocket } from '@kit.NetworkKit';
import { fileIo, WriteOptions } from '@kit.CoreFileKit';
import { cloudStorage } from '@kit.CloudFoundationKit';
import { BusinessError, request } from '@kit.BasicServicesKit';

//参考通过WebSocket连接访问CosyVoice语音合成服务的官方文档实现

// WebSocket连接的URL地址
const url = 'wss://dashscope.aliyuncs.com/api-ws/v1/inference/';
// 用户的API Key（请确保安全配置，不直接硬编码在生产环境中）
const apiKey = 'sk-8390fca298804bbe9457cb368c8767bb';  // 替换为你的API Key

// 定义接口,用于承载信息
interface HeaderOfTaskMessage {
  action: string;
  task_id: string;
  streaming: string;
}

interface HeaderofResponseMessage {
  event: string;
  task_id: string;
  error_message?: string;
}

interface ParametersofPayload {
  text_type: string;
  voice: string;
  format: string;
  sample_rate: number;
  volume: number;
  rate: number;
  pitch: number;
}

interface inputofText {
  text: string;
}

interface Payload {
  task_group: string;
  task: string;
  function: string;
  model: string;
  parameters: ParametersofPayload;
  input: inputofText;
}

interface TaskMessage {
  header: HeaderOfTaskMessage;
  payload: Payload;
}

interface ResponseMessage {
  header: HeaderofResponseMessage;
  payload: Payload;
}


// 唯一的task_id由外部传参，这样可以直接记录音频在云端的位置
export const createWebSocketConnection = (taskId:string,userText: string) => {
  // 写入二进制数据
  let context = getContext();
  let filesDir = context.cacheDir;
  let cachefilePath= filesDir + '/.'+taskId+'.mp3';
  let length=0;
  let taskStarted = false;
  const ws = webSocket.createWebSocket(); // 创建 WebSocket 连接

  let options: webSocket.WebSocketRequestOptions = {
    header: {
      Authorization: `bearer ${apiKey}`,
      'X-DashScope-DataInspection': 'enable'
    },
    // 根据需要设置 caPath，留空字符串可能导致 SSL 错误
    caPath: "" // 如果不需要自定义 CA 路径，可以省略或正确配置
  };

  // 打开WebSocket连接
  ws.connect(url, options, (err: BusinessError, value: Object) => {
    if (!err && value) {
      console.log('WebSocket连接已成功建立');

      // 发送run-task指令启动语音合成任务
      const runTaskMessage: TaskMessage = {
        header: {
          action: 'run-task',
          task_id: taskId, // 确保 taskId 是一个有效的字符串
          streaming: 'duplex',
        },
        payload: {
          task_group: 'audio',
          task: 'tts',
          function: 'SpeechSynthesizer',
          model: 'cosyvoice-v1',
          parameters: {
            text_type: 'PlainText',
            voice: 'longxiaochun',  // 设置音色
            format: 'mp3',  // 音频格式
            sample_rate: 22050,  // 采样率
            volume: 50,  // 音量
            rate: 1,  // 语速
            pitch: 1,  // 音调
          },
          input: {} as inputofText ,
        },
      };

      //将一个 JavaScript 对象（runTaskMessage）转换成一个 JSON 格式的字符串（runTaskMessageString）
      const runTaskMessageString = JSON.stringify(runTaskMessage);

      //发送
      ws.send(runTaskMessageString, (err: BusinessError, value: boolean) => {
        if (!err) {
          console.log('已发送run-task消息');
        } else {
          console.error('发送run-task消息失败:', err);
        }
      });
    } else {
      console.error('WebSocket连接失败:', err);
    }
  });

  // 监听消息返回
  ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
    if (typeof value === 'string') {
      const message: ResponseMessage = JSON.parse(value); // 明确声明为 ResponseMessage 类型

      // 根据消息类型处理
      switch (message.header.event) {
        case 'task-started':
          console.log('任务已开始');
          taskStarted=true;
          const texts = userText.split(",");
          texts.forEach((text, index) => {
            setTimeout(() => {
              if (taskStarted) {

                const continueTaskMessage = JSON.stringify({
                  header: {
                    action: 'continue-task',
                    task_id: taskId,
                    streaming: 'duplex',
                  } as HeaderOfTaskMessage,
                  payload: {
                    input: {
                      text: text,
                    },
                  }as Payload,
                });


                ws.send(continueTaskMessage, (err: BusinessError, value: boolean) => {
                  if (!err) {
                    console.log(`已发送continue-task，文本：${text}`);
                  } else {
                    console.error('发送continue-task消息失败:', err);
                  }
                });
              }
            }, 1000); // 每隔1秒发送一次文本
          });
          // 发送 finish-task 消息
          setTimeout(() => {
            if (taskStarted) {
              const finishTaskMessage = JSON.stringify({
                header: {
                  action: 'finish-task',
                  task_id: taskId,
                  streaming: 'duplex',
                } as HeaderOfTaskMessage,
                payload: {
                  input: {},
                } as Payload,
              });

              ws.send(finishTaskMessage, (err: BusinessError, value: boolean) => {
                if (!err) {
                  console.log('已发送finish-task');
                } else {
                  console.error('发送finish-task消息失败:', err);
                }
              });
            }
          }, texts.length*1000+1000); // 等待所有任务结束后再发送 finish-task
          break;
        case 'task-finished':
          console.log('任务已完成');
          //保存音频文件到云端
          let CloudPath = 'audio/'+taskId+'.mp3';
          let storageBucket: cloudStorage.StorageBucket = cloudStorage.bucket();

          storageBucket.uploadFile(getContext(), {
            localPath: cachefilePath,
            cloudPath: CloudPath,
          }).then((task: request.agent.Task) => {
            task.on('progress', (progress) => {
              console.info(`on progress ${JSON.stringify(progress)}`);
            });
            task.on('completed', (progress) => {
              console.info(`on completed ${JSON.stringify(progress)}`);
            });
            task.on('failed', (progress) => {
              console.error(`on failed ${JSON.stringify(progress)}`);
            });
            task.on('response', (response) => {
              console.info(`on response ${JSON.stringify(response)}`);
            });

            // start task
            task.start((err: BusinessError) => {
              if (err) {
                console.error(`Failed to start the uploadFile task, Code: ${err.code}, message: ${err.message}`);
              } else {
                console.info(`Succeeded in starting a uploadFile task.`);
              }
            });
          }).catch((err: BusinessError) => {
            console.error(`Upload file failed, Code: ${err.code}, message: ${err.message}`);
          });
          break;
        case 'task-failed':
          console.error('任务失败：', message.header.error_message);
          break;
        default:
          console.log('其他消息类型');
          break;
      }
    } else if (value instanceof ArrayBuffer) {  // 如果数据是二进制数据
      console.log('接收到二进制数据，正在写入文件...');

      //参考https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V13/js-apis-file-fs-V13#fswrite

      let file = fileIo.openSync(filesDir + '/.'+taskId+'.mp3', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      length+=value.byteLength;
      let option:WriteOptions={};
      option.offset=length;


      // 将二进制数据写入文件
      fileIo.write(file.fd, value,option).then((writeLen: number) => {
        console.info("write data to file succeed and size is:" + writeLen);
      }).catch((err: BusinessError) => {
        console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
      }).finally(() => {
        fileIo.closeSync(file);
      });



    } else {
      console.error('接收到非字符串和非二进制数据的消息');
    }
  }
  );


  // 主动断开连接
  ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
    console.log("on close, code is " + value.code + ", reason is " + value.reason);
  });

};

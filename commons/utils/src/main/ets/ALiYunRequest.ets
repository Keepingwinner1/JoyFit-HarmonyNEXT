import { http } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const apiKey='sk-698f44520b78462ebd9d991a8b25b19a';


interface MessageType {
  content: string;
}

interface MessageofDashscopeResponse {
  message: MessageType;
}

interface DashscopeResponse {
  choices: Array<MessageofDashscopeResponse>;
}

// 工具函数：与大模型进行交互
export const fetchDashscopeResponse = async (question: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    hilog.info(0x0000, 'DashscopeTag', 'DashscopeHttpUtils request invoke. question: %{public}s', question);

    let httpRequest = http.createHttp();

    httpRequest.request(
      "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
      {
        method: http.RequestMethod.POST,
        header: {
          "Content-Type": "application/json",
          "Authorization":"Bearer " +`${apiKey}` // 请替换为你的API Key
        },
        extraData: {
          "model": "qwen-plus",
          "messages": [
              {
                "role": "system",
                "content": "You are an experienced fitness expert with knowledge in various" +
                  "exercises and stretches. Your task is to provide detailed, safe, " +
                  "and effective exercise instructions to the user based on their descriptions. " +
                  "Ensure the instructions are clear, professional, and suitable for someone " +
                  "following them in a workout setting. Please provide your response in Chinese."

              },
              {
                "role": "user",
                "content": question
              }
            ]
          }
      },
      (err: Error, data: http.HttpResponse) => {
        if (err) {
          hilog.error(0x0000, 'DashscopeTag', 'Failed to request Dashscope. Cause: %{public}s', JSON.stringify(err) ?? '');
          reject('Request failed: ' + JSON.stringify(err));
        } else {
          try {
            const result: DashscopeResponse = JSON.parse(JSON.stringify(data.result));
            const messageContent = result?.choices?.[0]?.message?.content || 'No response content';

            hilog.info(0x0000, 'DashscopeTag', 'Request success. Response: %{public}s', result);
            resolve(messageContent);
          } catch (parseError) {
            hilog.error(0x0000, 'DashscopeTag', 'Failed to parse response: %{public}s', parseError.toString());
            reject('Response parse failed: ' + parseError.toString());
          }
        }
        httpRequest.destroy(); // 释放资源
      }
    );
  });
};




import { cloudStorage } from '@kit.CloudFoundationKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';


export class CloudStorageHelper {
  private storageBucket: cloudStorage.StorageBucket;

  constructor() {
    this.storageBucket = cloudStorage.bucket(); // 初始化云存储实例
  }


  //上传后能够返回路径，string的形式
  // 上传图片文件
  uploadImage(): Promise<boolean | string> {
    return this.selectAndUploadFile( photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE);
  }

  // 上传视频文件
  uploadVideo(): Promise<boolean | string> {
    return this.selectAndUploadFile( photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE);
  }



  /**
   * 选择文件并上传到云端
   * @param mimeType 文件类型 (image/*, video/*)
   */
  async selectAndUploadFile(mimeType: string): Promise<boolean |string> {
    try {
      // 1. 配置文件选择器
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      let cloudPathPrefix: string;

      switch (mimeType) {
        case 'image/*':
          photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
          cloudPathPrefix = 'image/';
          break;
        case 'video/*':
          photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
          cloudPathPrefix = 'video/';
          break;
        default:
          console.error(`Unsupported MIME type: ${mimeType}`);
          return false;
      }

      photoSelectOptions.maxSelectNumber = 1; // 允许选择一个文件
      const picker = new photoAccessHelper.PhotoViewPicker();
      const result = await picker.select(photoSelectOptions);

      if (!result || result.photoUris.length === 0) {
        console.warn('No file selected.');
        return false;
      }

      // 2. 复制文件到缓存目录
      const fileUri = result.photoUris[0];
      const fileName = fileUri.split('/').pop() as string;
      const cacheFilePath = `${getContext().cacheDir}/${fileName}`;

      this.copyFileToCache(fileUri, cacheFilePath);
      console.info(`File copied to cache directory: ${cacheFilePath}`);

      // 3. 确定云端存储路径
      const cloudPath = `${cloudPathPrefix}${fileName}`;
      console.info(`Cloud path: ${cloudPath}`);

      // 4. 上传文件到云端
      const task = await this.storageBucket.uploadFile(getContext(this), {
        localPath: cacheFilePath,
        cloudPath: cloudPath,
      });

      // 5. 监听任务事件
      this.addTaskListeners(task, cloudPath);

      // 6. 启动上传任务
      // 6. 启动上传任务并确保返回值在上传完成后
      return new Promise<string | boolean>((resolve) => {
        task.start((err: BusinessError) => {
          if (err) {
            console.error(`Failed to start upload task! Code: ${err.code}, Message: ${err.message}`);
            resolve(false);  // Resolve with false if the upload fails
          } else {
            console.info('Upload task started.');
            resolve(cloudPath);  // Resolve with cloudPath if the upload starts successfully
          }
        });
      });
    } catch (error) {
      console.error(`Error selecting or uploading file: ${error}`);
      return false;
    }
  }

  /**
   * 复制文件到缓存目录
   * @param src 原文件路径
   * @param dest 目标路径 (缓存目录)
   */
  private copyFileToCache(src: string, dest: string): void {
    const srcFile = fileIo.openSync(src);
    const dstFile = fileIo.openSync(dest, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    fileIo.copyFileSync(srcFile.fd, dstFile.fd);
    fileIo.closeSync(srcFile);
    fileIo.closeSync(dstFile);
  }

  /**
   * 监听上传任务事件
   * @param task 上传任务
   * @param cloudPath 云端存储路径
   */
  private addTaskListeners(task: request.agent.Task, cloudPath: string): void {
    task.on('progress', (progress) => {
      console.info(`Upload progress: ${(progress.processed / progress.sizes[0] * 100).toFixed(2)}%`);
    });

    task.on('completed', () => {
      console.info(`File successfully uploaded to: ${cloudPath}`);
    });

    task.on('failed', (progress) => {
      console.error(`Upload failed: ${JSON.stringify(progress)}`);
    });

    task.on('response', (response) => {
      console.info(`Upload response: ${JSON.stringify(response)}`);
    });
  }

  // 获取云侧文件下载地址，要带audio/
  getDownloadURL(fileName: string): Promise<string> {
    return this.storageBucket.getDownloadURL(fileName).then((downloadURL: string) => {
      console.info(`Download URL: ${downloadURL}`);
      return downloadURL;
    }).catch((err: BusinessError) => {
      console.error(`Failed to get download URL, Code: ${err.code}, message: ${err.message}`);
      throw new Error("获取云侧文件下载地址失败");

    });
  }

  // 删除云侧文件
  deleteFile(fileName: string): Promise<void> {
    return this.storageBucket.deleteFile(fileName).then(() => {
      console.info(`File deleted successfully: ${fileName}`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to delete file, Code: ${err.code}, message: ${err.message}`);
      throw new Error("删除文件失败");
    });
  }

  // 下载云侧文件到本地
  downloadFile(fileName: string): Promise<void> {
    return this.storageBucket.downloadFile(getContext(this), {
      localPath: `${getContext().cacheDir}/${fileName}`, // 确保存储路径在缓存目录下
      cloudPath: fileName,                             // 云侧文件路径
      overwrite: true,                                 // 覆盖同名文件
    }).then((task: request.agent.Task) => {
      // 监听任务事件
      task.on('progress', (progress) => {
        console.info(`Download progress: ${JSON.stringify(progress)}`);
      });

      task.on('completed', (progress) => {
        console.info(`Download completed: ${JSON.stringify(progress)}`);
      });

      task.on('failed', (progress) => {
        console.error(`Download failed: ${JSON.stringify(progress)}`);
      });

      task.on('response', (response) => {
        console.info(`Response received: ${JSON.stringify(response)}`);
      });

      // 启动下载任务
      task.start((err: BusinessError) => {
        if (err) {
          console.error(`Failed to start download task, Code: ${err.code}, Message: ${err.message}`);
        } else {
          console.info(`Download task started successfully.`);
        }
      });
    }).catch((err: BusinessError) => {
      console.error(`Download failed, Code: ${err.code}, Message: ${err.message}`);
    });
  }

}



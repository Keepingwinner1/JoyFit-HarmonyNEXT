import * as wxopensdk from '@tencent/wechat_open_sdk';
import { common } from '@kit.AbilityKit';

export class WeChatShare {
  private wxApi: wxopensdk.WXApi;

  constructor(appId: string) {
    // 初始化微信 API
    this.wxApi = wxopensdk.WXAPIFactory.createWXAPI(appId);
  }

  /**
   * 分享文字和图片到微信好友
   * @param context - UIAbilityContext，上下文
   * @param text - 要分享的文字内容
   * @param imageUri - 本地图片路径
   */
  async shareTextAndImage(
    context: common.UIAbilityContext,
    text: string,
    imageUri: string
  ): Promise<void> {
    try {
      // 1. 发送文字消息
      await this.sendTextMessage(context, text);
      console.log("文字分享完成");

      // 2. 发送图片消息
      await this.sendImageMessage(context, imageUri);
      console.log("图片分享完成");
    } catch (error) {
      console.error("分享失败: ", error);
    }
  }

  // 发送文字消息
  private async sendTextMessage(context: common.UIAbilityContext, text: string): Promise<void> {
    let textObject = new wxopensdk.WXTextObject();
    textObject.text = text;

    let mediaMessage = new wxopensdk.WXMediaMessage();
    mediaMessage.mediaObject = textObject;

    let req = new wxopensdk.SendMessageToWXReq();
    req.scene = wxopensdk.SendMessageToWXReq.WXSceneSession; // 发送到微信好友
    req.message = mediaMessage;

    await this.wxApi.sendReq(context, req);
  }

  // 发送图片消息
  private async sendImageMessage(context: common.UIAbilityContext, imageUri: string): Promise<void> {
    let imageObject = new wxopensdk.WXImageObject();
    imageObject.uri = imageUri;

    let mediaMessage = new wxopensdk.WXMediaMessage();
    mediaMessage.mediaObject = imageObject;

    let req = new wxopensdk.SendMessageToWXReq();
    req.scene = wxopensdk.SendMessageToWXReq.WXSceneSession; // 发送到微信好友
    req.message = mediaMessage;

    await this.wxApi.sendReq(context, req);
  }
}





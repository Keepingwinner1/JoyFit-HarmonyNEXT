import { ComposeListItem } from '@ohos.arkui.advanced.ComposeListItem'
import { font, router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct VideoPlayPage {
  @Local isPlaying: boolean = true

  build() {
    Column() {
      //总进度条
      Progress({value: 10, total: 80, type:ProgressType.Linear})
        .style({strokeWidth: 6, enableSmoothEffect: true})
        .color('#24c789')
        .margin({top: 20, left: 20, right: 20})

      //文字
      Row() {
        Text('1/14 腹肌激活')
          .width('100%')
          .fontColor('#5c5c5f')
          .fontWeight(FontWeight.Medium)
          .fontSize(20)
      }
      .margin({top: 5, left: 20, right: 20})
      .justifyContent(FlexAlign.Start)

      //todo 放视频
      // Image($r('app.media.videotest'))
      //   .height(450)

      Blank()

      //控制组件
      Column() {
        Row() {
          Progress({value: 10, total: 80, type:ProgressType.Linear})
            .style({strokeWidth: 30, enableSmoothEffect: true, strokeRadius: 6})
            .width('50%')
            .backgroundColor('#3cffffff')
            .color('#24c789')

          Text('00:09')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .fontSize(28)
            .margin({left: 14})

          Blank()

          Text('0')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .fontSize(28)
        }
        .margin({top: 10})
        .width('100%')

        Row() {
          Row() {
            Image($r('app.media.ic_backward_end_fill'))
              .width(26)
              .fillColor('#a4ffffff')
          }
          .backgroundColor('#34ffffff')
          .width(40)
          .height(40)
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .padding(5)

          Row() {
            if(this.isPlaying) //暂停按钮
              Row() {
                Image($r('app.media.ic_pause'))
                  .width(26)
                  .fillColor('#3a3340')
              }
              .backgroundColor('#fff')
              .width(40)
              .height(40)
              .borderRadius(20)
              .justifyContent(FlexAlign.Center)
              .padding(5)
              .onClick(() => {
                this.isPlaying = !this.isPlaying
              })

            else {
              Row({space: 30}) {
                Row() { //终止按钮
                  Row()
                    .width(18)
                    .height(18)
                    .backgroundColor(Color.White)
                }
                .backgroundColor('#fd5b54')
                .width(40)
                .height(40)
                .borderRadius(20)
                .justifyContent(FlexAlign.Center)
                .padding(5)
                .onClick(() => {
                  router.back()
                })
                Row() { //继续按钮
                  Image($r('app.media.ic_play_fill'))
                    .width(22)
                    .fillColor(Color.White)
                }
                .backgroundColor('#26c688')
                .width(40)
                .height(40)
                .borderRadius(20)
                .justifyContent(FlexAlign.Center)
                .padding(5)
                .onClick(() => {
                  this.isPlaying = !this.isPlaying
                })
              }
            }
          }



          Row() {
            Image($r('app.media.ic_forward_end_fill'))
              .width(26)
              .fillColor('#a4ffffff')
          }
          .backgroundColor('#34ffffff')
          .width(40)
          .height(40)
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .padding(5)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({top: 20, bottom: 8})
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#3a3340')
      .borderRadius({topLeft: 10, topRight: 10})
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.test_video'))
    .backgroundImageSize({height: '100%'})
    .backgroundImagePosition(Alignment.Center)
  }

  // @Builder
  // icon(imageUrl: string, fillColor: string, backgroundColor: string) {
  //   Row() {
  //     Image($r(imageUrl))
  //       .width(26)
  //       .fillColor(fillColor)
  //   }
  //   .backgroundColor(backgroundColor)
  //   .width(40)
  //   .height(40)
  //   .borderRadius(20)
  //   .justifyContent(FlexAlign.Center)
  //   .padding(5)
  // }
}

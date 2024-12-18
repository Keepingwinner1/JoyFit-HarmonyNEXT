import { ComposeListItem } from '@ohos.arkui.advanced.ComposeListItem'
import { font, router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct VideoPlayPage {
  @Local isPlaying: boolean = true
  @Local time: number = 0

  @Local isCompleted: boolean = false
  @Local maskOpacity: number = 0
  @Local maskImgX: number = 0
  @Local maskImgY: number = 0

  private intervalID = setInterval(() => {
    this.time++
  }, 1000)

  build() {
    Stack() {
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

        Button('完成训练')
          .onClick(() => {
            this.isCompleted = !this.isCompleted
            this.maskOpacity = 1
            this.maskImgX = 1
            this.maskImgY = 1
            clearInterval(this.intervalID);
          })

        //控制组件
        Column() {
          Row() {
            Progress({value: 10, total: 80, type:ProgressType.Linear})
              .style({strokeWidth: 30, enableSmoothEffect: true, strokeRadius: 6})
              .width('50%')
              .backgroundColor('#3cffffff')
              .color('#24c789')

            Text(this.showTime())
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .fontSize(28)
              .margin({left: 14})
          }
          .margin({top: 10})
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

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
                clearInterval(this.intervalID);
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
                    this.intervalID = setInterval(() => {
                      this.time++
                    }, 1000)
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

      Column() {
        Column() {
          Text('恭喜您完成训练')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.badge_top_points'))
            .height(130)
            .margin({top: 30})
            .scale({
              x: this.maskImgX,
              y: this.maskImgY
            })
            .animation({
              duration: 400
            })
          Blank()
          Row() {
            Blank()
            Row() {
              Text('写下此刻的感受')
                .fontSize(12)
                .fontColor('#9e000000')
              Image($r('app.media.ic_paintbrush_fill'))
                .height(20)
                .fillColor('#9e000000')
                .margin({left: 5})
            }
            .backgroundColor('#19000000')
            .padding(10)
            .borderRadius(8)
            .onClick(() => {
              router.replaceUrl({
                url: "pages/AddRecordPage"
              })
            })
          }
          .width('100%')
        }
        .backgroundColor(Color.White)
        .height(300)
        .width(250)
        .borderRadius(20)
        .padding(20)

        Row() {
          Image($r('app.media.ic_xmark'))
            .height(40)
            .fillColor(Color.White)
        }
        .margin({top: 70})
        .backgroundColor('#90000000')
        .width(100)
        .justifyContent(FlexAlign.Center)
        .padding(10)
        .borderRadius(15)
        .borderWidth(2)
        .borderColor(Color.White)
        .onClick(() => {
          // this.isCompleted = !this.isCompleted
          // this.maskOpacity = 0
          // this.maskImgX = 0
          // this.maskImgY = 0
          router.back()
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ce000000')
      .zIndex(this.isCompleted ? 5 : -1)
      .justifyContent(FlexAlign.Center)
      .opacity(this.maskOpacity)
      .animation({
        duration: 300
      })

    }

  }

  private showTime(): string {
    let min: number = Math.floor(this.time / 60)
    let sec: number = (this.time % 60)
    let ans: string = ''
    if (min > 9) ans += min.toString()
    else if (min > 0) ans += `0${min.toString()}`
    else ans += '00'
    ans += ':'
    if (sec > 9) ans += sec.toString()
    else if (sec > 0) ans += `0${sec.toString()}`
    else ans += '00'
    return ans
  }
}

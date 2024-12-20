import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct RunPage {
  @Local isRunning: boolean = true

  build() {
    Column() {
      Image($r('app.media.test_running_map'))
        .height(560)
      Column() {
        Row() {
          Column() {
            Text('0.00')
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .fontSize(28)
              .margin({left: 14})
            Text('总距离')
              .fontColor('#9effffff')
              .fontSize(14)
              .margin({left: 10})
          }
          Column() {
            Text('00:10')
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .fontSize(28)
              .margin({left: 14})
            Text('总时长')
              .fontColor('#9effffff')
              .fontSize(14)
          }
          Column() {
            Text('5\'11\'\'')
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .fontSize(28)
            Text('实时配速')
              .fontColor('#9effffff')
              .fontSize(14)
          }
        }
        .margin({top: 10})
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Row() {
            if(this.isRunning)
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
              this.isRunning = !this.isRunning
            })

            else {
              Row({space: 30}) {
                Row() {
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
                Row() {
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
                  this.isRunning = !this.isRunning
                })
              }
            }
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({top: 20, bottom: 8})
      }
      .width('100%')
      .padding({top: 20, left: 20, right: 20, bottom: 40})
      .backgroundColor('#3a3340')
      .borderRadius({topLeft: 10, topRight: 10})
    }
  }
}

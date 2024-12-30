import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct AddRecordPage {
  @Local txt: string = ''
  @Local title: string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_chevron_left'))
          .height(30)
          .onClick(() => {
            router.back()
          })
        Text('添加记录')
        Text('完成')
          .backgroundColor(Color.Green)
          .fontColor(Color.White)
          .padding({top: 5, bottom: 5, left: 10, right: 10})
          .borderRadius(10)
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: 30, right: 30, bottom: 15})
      .backgroundColor(Color.White)


      TextInput({
        placeholder: '请输入该记录标题',
        text: $$this.title
      })
        .margin({top: 30, left: 20, right: 20})
        .backgroundColor(Color.White)
      TextArea({
        placeholder: '记录此刻的感受',
        text: $$this.txt
      })
        .backgroundColor(Color.White)
        .margin({top: 10, left: 20, right: 20})
        .height(200)

      Row() {
        Row() {
          Text('+')
            .fontSize(56)
            .fontWeight(FontWeight.Lighter)
        }
        .margin({top: 10, left: 20, right: 20})
        .backgroundColor(Color.White)
        .width(80)
        .height(80)
        .justifyContent(FlexAlign.Center)
        .borderRadius(20)
        .borderWidth(1)
        .borderColor('#95000000')
        .borderStyle(BorderStyle.Dashed)
      }
      .width('100%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor("#ffeeeeee")
  }
}

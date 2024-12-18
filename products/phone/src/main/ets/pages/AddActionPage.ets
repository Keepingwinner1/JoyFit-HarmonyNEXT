import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct AddActionPage {
  @Local actionName: string = ''
  @Local actionType: string = '胸'
  @Local actionDescription: string = ''

  private trainingPartList: string[] = ['胸', '背', '肩', '手臂', '腹部', '腿']
  private select: number | number[] = 0

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_chevron_left'))
          .height(30)
          .onClick(() => {
            router.back()
          })
        Text('创建动作')
        Image($r('app.media.ic_plus_square'))
          .height(30)
          .fillColor("#ffeeeeee")
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: 30, right: 30})

      Column() {
        TextInput({
          placeholder: '请输入动作名称',
          text: $$this.actionName
        })
          .backgroundColor(Color.White)
          .height(60)
          .width('100%')
          .borderRadius({topLeft: 10, topRight: 10})
        Row() {
          Text('动作分类')
          Blank()
          Text(this.actionType)
          Image($r('app.media.ic_chevron_right'))
            .height(20)
            .fillColor('#52000000')
            .margin({left: 10})
        }
        .width('100%')
        .height(60)
        .backgroundColor(Color.White)
        .padding(20)
        .onClick(() => {
          TextPickerDialog.show({ // 建议使用 this.getUIContext().showTextPickerDialog()接口
            range: this.trainingPartList,
            selected: this.select,
            disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
            textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
            selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
            onAccept: (value: TextPickerResult) => {
              // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
              this.select = value.index
              // 点击确定后，被选到的文本数据展示到页面
              this.actionType = value.value as string
            }
          })
        })

        Row() {
          Text('动作图片')
          Blank()
          Text('可选')
            .fontColor('#52000000')
          Image($r('app.media.ic_chevron_right'))
            .height(20)
            .fillColor('#52000000')
            .margin({left: 10})
        }
        .width('100%')
        .height(60)
        .backgroundColor(Color.White)
        .padding(20)
        .borderRadius({bottomLeft: 10, bottomRight: 10})
      }
      .margin({top: 20})

      TextArea({
        placeholder: '\n                    请输入动作描述',
        text: $$this.actionDescription
      })
        .backgroundColor(Color.White)
        .margin({top: 20})
        .height(80)

      Blank()

      Button('创建动作')
        .width('100%')
        .onClick(() => {
          router.back()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#ffeeeeee")
    .padding(20)
  }
}

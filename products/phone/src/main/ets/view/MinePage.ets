
@ComponentV2
export default struct MinePage {
  @Local nickname: string = '混元形意掌门人'

  build() {
    Column() {
      Image($r('app.media.test_plan_cover'))
        .width(100)
        .height(100)
        .borderRadius(50)
        .margin({top: 30})

      Text(this.nickname)
        .margin({top: 30})
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor("#ffeeeeee")
  }
}

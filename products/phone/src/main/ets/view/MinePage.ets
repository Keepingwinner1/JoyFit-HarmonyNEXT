import Badge from '../model/Badge'


@ComponentV2
export default struct MinePage {
  @Local nickname: string = '混元形意掌门人'

  private badges: Badge[] = [new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_time_online', '累计登录七天'), ]

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

      Column() {
        GridRow({
          columns: 4,
          gutter: { x: 5, y: 10 },
          breakpoints: { value: ["400vp", "600vp", "800vp"],
            reference: BreakpointsReference.WindowSize },
          direction: GridRowDirection.Row
        }) {
          ForEach(this.badges, (item: Badge, index) => {
            GridCol({ span: { xs: 1, sm: 2, md: 3, lg: 4 }, offset: 0, order: 0 }) {
              Image($r(item.imageUrl))
                .height(60)
            }
          })
        }.width("100%")
      }
      .backgroundColor(Color.White)
      .padding(10)
      .borderRadius(10)
      .margin({top: 30})


      // GridRow({
      //   columns: 5,
      //   gutter: { x: 5, y: 10 },
      //   direction: GridRowDirection.Row
      // }) {
      //   ForEach(this.badges, (item: Badge, index) => {
      //     GridCol() {
      //       Image($r(item.imageUrl))
      //         .height(40)
      //     }
      //   })
      // }

      // Image($r('app.media.badge_none'))
      //   .height(50)
      //   .fillColor('#2d000000')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor("#ffeeeeee")
    .padding(20)
  }
}

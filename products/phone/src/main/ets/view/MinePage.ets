import Badge from '../model/Badge'


@ComponentV2
export default struct MinePage {
  @Local nickname: string = '混元形意掌门人'
  @Local isPresentBadge: boolean = false
  @Local presentBadge: Badge = new Badge('app.media.badge_time_online', '累计登录七天')
  @Local maskOpacity: number = 0
  @Local maskImgX: number = 0
  @Local maskImgY: number = 0

  private badges: Badge[] = [new Badge('app.media.badge_time_online', '累计登录七天'),
    new Badge('app.media.badge_communicator', '累计登录七天'),
    new Badge('app.media.badge_conversation_starter', '累计登录七天'),
    new Badge('app.media.badge_friends_invited', '累计登录七天'),
    new Badge('app.media.badge_popular_thread', '累计登录七天'),
    new Badge('app.media.badge_top_points', '累计登录七天'),
    new Badge('app.media.badge_thanks_giver', '累计登录七天'), ]

  build() {
    Stack() {
      //主体层
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
          Text('我的成就')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({bottom: 10})
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
              .onClick(() => {
                this.isPresentBadge = !this.isPresentBadge
                this.presentBadge = item
                this.maskOpacity = 1
                this.maskImgX = 1
                this.maskImgY = 1
              })
            })
          }.width("100%")
        }
        .backgroundColor(Color.White)
        .padding(10)
        .borderRadius(10)
        .margin({top: 30})
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor("#ffeeeeee")
      .padding(20)

      //遮罩层
      Column() {
        Column() {
          Text('恭喜您获得成就')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Image($r(this.presentBadge.imageUrl))
            .height(130)
            .margin({top: 30})
            .scale({
              x: this.maskImgX,
              y: this.maskImgY
            })
            .animation({
              duration: 400
            })
          Text(this.presentBadge.description)
            .margin({top: 20})
        }
        .backgroundColor(Color.White)
        .height(300)
        .width(250)
        .borderRadius(20)
        .padding(20)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ce000000')
      .zIndex(this.isPresentBadge ? 5 : -1)
      .justifyContent(FlexAlign.Center)
      .opacity(this.maskOpacity)
      .animation({
        duration: 300
      })
      .onClick(() => {
        this.isPresentBadge = !this.isPresentBadge
        this.maskOpacity = 0
        this.maskImgX = 0
        this.maskImgY = 0
      })
    }

  }
}

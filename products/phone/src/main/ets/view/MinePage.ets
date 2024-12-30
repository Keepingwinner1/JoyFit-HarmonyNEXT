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
        Row() {
          Image($r('app.media.ic_gearshape'))
            .height(30)
            .margin({right: 10})
        }.width('100%').justifyContent(FlexAlign.End)
        Image($r('app.media.test_plan_cover'))
          .width(100)
          .height(100)
          .borderRadius(50)

        Text(this.nickname)
          .margin({top: 30})
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        //成就
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

        Row() {
          Column() {
            Text('BMI指数')
              .fontSize(16)
              .margin({top: 10})
            Gauge({ value: 21, min: 10, max: 32 }) {
              Column() {
                Text('86')
                  .maxFontSize("80sp")
                  .minFontSize("60.0vp")
                  .fontWeight(FontWeight.Medium)
                  .fontColor("#ff182431")
                  .width('40%')
                  .height('30%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: '22.2%' })
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }.width('100%').height('100%')
            }
            .startAngle(225)
            .endAngle(135)
            // .colors(new LinearGradient([{ color: "#e84026", offset: 0 },
            //   { color: "#f7ce00", offset: 0.6 },
            //   { color: "#64bb5c", offset: 1 }]))
            .colors(new LinearGradient([{ color: "#e84026", offset: 0 },
              { color: "#f7ce00", offset: 0.2 },
              { color: "#64bb5c", offset: 0.5 },
              { color: "#f7ce00", offset: 0.8 },
              { color: "#e84026", offset: 1 }]))
            .width('100%')
            .height('100%')
            .strokeWidth(18)
            .trackShadow({ radius: 7, offsetX: 7, offsetY: 7 })
            .padding(18)
          }.width('45%')
          .backgroundColor(Color.White)
          .borderRadius(10)

          Blank()

          // 体质表信息
          Column() {

          }.width('45%').height(180)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }.width('100%').height(180)
        .margin({top: 20})
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
          Text('成就名')
            .margin({top: 10})
          Image($r(this.presentBadge.imageUrl))
            .height(130)
            .margin({top: 15})
            .scale({
              x: this.maskImgX,
              y: this.maskImgY
            })
            .animation({
              duration: 400
            })
          Text(this.presentBadge.description)
            .margin({top: 20})
          Text('获得时间：2024年12月16日')
            .fontSize(14)
            .fontColor('#9e000000')
            .margin({top: 10})
        }
        .backgroundColor(Color.White)
        .height(300)
        .width(250)
        .borderRadius(20)
        .padding(20)
        .margin({top: 150})

        Row() {
          Text('分享')
          Image($r('app.media.ic_arrowshape_turn_up_right_fill')).height(30)
        }
        .backgroundColor(Color.White)
        .height(50)
        .width(100)
        .borderRadius(25)
        .justifyContent(FlexAlign.Center)
        .margin({top: 100})
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ce000000')
      .zIndex(this.isPresentBadge ? 5 : -1)
      //.justifyContent(FlexAlign.Center)
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

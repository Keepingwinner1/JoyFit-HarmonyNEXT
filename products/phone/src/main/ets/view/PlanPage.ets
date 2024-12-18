import { ComposeListItem } from '@ohos.arkui.advanced.ComposeListItem'
import { router } from '@kit.ArkUI'

enum PlanStatus { Completed, Doing, Fail, Todo}


@ComponentV2
export default struct PlanPage {
  build() {
    Column() {
      Swiper() {
        Image($r('app.media.test_plan_cover'))
        Image($r('app.media.test_poster1'))
        Image($r('app.media.test_poster2'))
        Image($r('app.media.test_poster1'))
      }
      .width('100%')
      .height(150)
      .loop(true)
      .autoPlay(true)
      .interval(3000)
      .borderRadius(10)
      .indicator(
        Indicator.dot()
          .itemWidth(10) //默认宽
          .itemHeight(3)
            //默认颜色：.color()
          .selectedItemWidth(30)
          .selectedColor(Color.White)
      )

      Scroll() {
        Column() {
          Text('正在执行')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .decoration({ type: TextDecorationType.Underline, color: Color.Black })
            .width('100%')
            .margin({top: 20})
          planItem({
            planName: '腹肌撕裂者',
            planCover: 'app.media.planCover',
            tag: '#腹肌 #核心',
            time: '45min',
            type: PlanStatus.Doing
          })
          planItem({
            planName: '举重训练',
            planCover: 'app.media.poster1',
            tag: '#胸肌 #力量',
            time: '30min',
            type: PlanStatus.Doing
          })

          Row() {
            Text('即将进行')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .decoration({ type: TextDecorationType.Underline, color: Color.Black })
              .margin({top: 10, bottom: 10})
            Row() {
              Text('新增计划')
                .fontWeight(FontWeight.Bold)
                .margin({right: 5})
                .fontColor('#b05e74f5')
              Image($r('app.media.ic_plus_square'))
                .height(30)
                .fillColor('#ff5e74f5')
            }
            .onClick(() => {
              router.pushUrl({
                url: "pages/CreatePlanPage"
              })
            })

          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          planItem({
            planName: '举重训练',
            planCover: 'app.media.poster1',
            tag: '#胸肌 #力量',
            time: '30min',
            type: PlanStatus.Todo
          })

          Text('历史计划')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .decoration({ type: TextDecorationType.Underline, color: Color.Black })
            .margin({top: 10})
            .width('100%')
          planItem({
            planName: '举重训练',
            planCover: 'app.media.poster1',
            tag: '#胸肌 #力量',
            time: '30min',
            type: PlanStatus.Fail
          })
          planItem({
            planName: '举重训练',
            planCover: 'app.media.poster1',
            tag: '#胸肌 #力量',
            time: '30min',
            type: PlanStatus.Completed
          })
        }
      }
      .scrollBar(BarState.Off)
      .height(485)
      .edgeEffect(EdgeEffect.Spring)


    }
    .width('100%')
    .height('100%')
    .padding({top: 20, left: 40, right: 40})
    .backgroundColor("#eeeeee")
  }
}

@ComponentV2
struct planItem {
  @Param planName: string = ''
  @Param planCover: string = ''
  @Param tag: string = ''
  @Param time: string = ''
  @Param type: PlanStatus = PlanStatus.Completed

  private statusImage: string = ''
  private statusText: string = ''
  private statusColor: string = ''

  aboutToAppear(): void {
    if(this.type == PlanStatus.Completed) {this.statusImage = 'app.media.ic_checkmark'; this.statusText = '已完成'; this.statusColor = '#ff43cd0e'}
    else if(this.type == PlanStatus.Doing) {this.statusImage = 'app.media.ic_fast_forward'; this.statusText = '进行中'; this.statusColor = '#ffdd4141'}
    else if(this.type == PlanStatus.Fail) {this.statusImage = 'app.media.ic_xmark'; this.statusText = '已放弃'; this.statusColor = '#ff474747'}
    else if(this.type == PlanStatus.Todo) {this.statusImage = 'app.media.ic_clock'; this.statusText = '待开始'; this.statusColor = '#fffa6a0a'}
  }

  build() {
    Row() {
      Image($r(this.planCover))
        .height('100%')
        .borderRadius(10)

      Column() {
        Text(this.planName)
          .fontWeight(FontWeight.Bold)
        Column() {
          Text(this.tag)
            .fontSize(12)
            .fontColor('#6d000000')
            .fontWeight(FontWeight.Bold)
          Text(this.time)
            .fontSize(12)
            .fontColor('#6d000000')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .margin({left: 10})

      Blank()

      Column() {
        Row() {
          Image($r(this.statusImage))
            .height('100%')
            .width('100%')
            .fillColor(this.statusColor)
        }
        .height(30)
        .width(30)
        .borderRadius(15)
        .backgroundColor(Color.White)
        .borderColor(this.statusColor)
        .borderWidth(2)
        .padding(6)
        .margin({bottom: 8})

        Text(this.statusText)
          .fontColor(this.statusColor)
          .fontSize(14)
      }

    }
    .backgroundColor(Color.White)
    .padding(14)
    .height(80)
    .width('100%')
    .borderRadius(20)
    .margin({bottom: 5, top: 10})
  }
}

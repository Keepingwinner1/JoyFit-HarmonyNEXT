import { bar } from '@mcui/mccharts/src/main/ets/mcCore/core'
import {mcLineChart} from './mccharts'

@ComponentV2
export default struct SportsDataPage {


  build() {
    Column() {
      Text('运动统计')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .decoration({ type: TextDecorationType.Underline, color: Color.Black })
        .width('100%')
        .margin({bottom: 10})
      //今日运动数据显示区域
      Row({space: 10}) {
        steps()
        calories()
      }
      exerciseDuration()

      //查看今日任务区域
      todayTask()
        .height('100%')
    }
    .width('100%')
    .height('100%')
    .padding({top: 20, left: 40, right: 40})
    .backgroundColor("#ffeeeeee")
  }
}

@ComponentV2
struct steps {
  @Local stepsValue: number[] = [9964, 6031, 1551, 8256, 10208, 4456, 14998]
  @Local selectedDate: number = 6
  build() {
    Column() {
      Row() {
        Column() {
          Text('步数')
            .fontColor("#94e2fd")
            .fontSize(12)
          Text(this.stepsValue[this.selectedDate].toString())
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({top: 20, left: 10})

        Image($r('app.media.ic_figure_running'))
          .width(50)
          .fillColor("#ff8ad5f3")
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)


      Scroll() {
        Row() {
          ForEach(this.stepsValue, (item: number, index) => {
            Column() {
              Text(`12月${(index + 10).toString()}日`)
                .fontSize(7)
                .fontColor(index == this.selectedDate ? Color.White : '#a4ffffff')
                .margin({bottom: 5})
                .fontWeight(FontWeight.Bold)
              Column() {
                ForEach(Array.from({ length: item / 1300 }), () => {
                  Column().width(15).height(3).backgroundColor(index == this.selectedDate ? Color.White : '#a4ffffff').margin({bottom: 5}).borderRadius(5)
                })
              }
              .height(100)
              .width(20)
              .backgroundColor("#ff50a4f6")
              .justifyContent(FlexAlign.End)
              .borderRadius(5)
            }
            .margin({left: 7})
            .onClick(() => {
              this.selectedDate = index
            })
          })
        }
        .reverse(false)
        .padding(10)
      }
      .width('100%')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .initialOffset({ xOffset: '100%'})
    }
    .width('50%')
    .height(200)
    .backgroundColor("#ff2191fa")
    .borderRadius(20)
  }
}

@ComponentV2
struct calories {
  build() {
    Column() {
      Row() {
        Column() {
          Text('今日卡路里消耗')
            .fontColor("#94e2fd")
            .fontSize(12)
          Text('8960')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({top: 20, left: 10})

        Image($r('app.media.ic_figure_arms_open'))
          .width(50)
          .fillColor("#ff56f3c2")
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      //显示折线图
      mcLineChart()
        .width('100%')
        .height('80%')
    }
    .width('50%')
    .height(200)
    .backgroundColor("#0bbe86")
    .borderRadius(20)
  }
}

@ComponentV2
struct exerciseDuration {
  @Local timeList: number[] = [10, 30, 20, 28, 16, 48, 43]

  build() {
    Row() {
      Column() {
        Text('运动时长')
          .fontColor('#ff838383')
        Row() {
          Text('56')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({right: 3})
          Text('min')
            .margin({right: 6})
          Image($r('app.media.ic_arrowtriangle_down_fill'))
            .height(20)
            .fillColor("#ff22bc8d")
            .margin({right: 5})
          Text('2%')
            .fontSize(14)
        }
        .alignItems(VerticalAlign.Bottom)
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)

      //显示柱状图
      Row() {
        ForEach(this.timeList, (item: number, index) =>{
          Column().height(item).width(13).margin(2).backgroundColor(index == 6 ? "#ff22bc8d": "#7a22bc8d")
        })
      }
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .height(100)
    .backgroundColor(Color.White)
    .margin({top: 20})
    .borderRadius(20)
    .padding(20)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@ComponentV2
struct todayTask {
  @Local isWorkOut: boolean = true

  build() {
    Column() {
      Row() {
        Text('今日待办')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .decoration({ type: TextDecorationType.Underline, color: Color.Black })
        Row() {
          Text(this.isWorkOut ? '健身' : '跑步')
            .fontColor(Color.White)
          Image($r('app.media.ic_reverse_order'))
            .width(20)
            .margin({left: 10})
            .fillColor(Color.White)
        }
        .padding(8)
        .backgroundColor("#ff2191fa")
        .borderRadius(15)
        .onClick(() => {
          this.isWorkOut = !this.isWorkOut
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)
      .margin({bottom: 10})

      List() {
        ForEach(Array.from({length: 4}), () => {
          ListItem () {
            listItem({
              coverURL: this.isWorkOut ? 'app.media.test_plan_cover' : 'app.media.test_poster1',
              planName: this.isWorkOut ? '腹肌撕裂者' : '举重训练'
            }).margin({top: 10})
          }
        })
      }
      .height(215)
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .margin({top: 20})
  }
}

@ComponentV2
struct listItem {
  @Param coverURL: string = '';
  @Param planName: string = ''
  build() {
    Row() {
      Image($r(this.coverURL))
        .width(50)
        .borderRadius(10)
      Column() {
        Text(this.planName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Text('45 分钟')
          .fontSize(12)
          .fontColor('#ff6b6b6b')
          .margin({right: 5})
      }
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({left: 10})

      Blank()

      Image($r('app.media.ic_chevron_right'))
        .width(20)
    }
    .width('100%')
    .height(80)
    .borderRadius(20)
    .backgroundColor(Color.White)
    .padding(15)
  }
}

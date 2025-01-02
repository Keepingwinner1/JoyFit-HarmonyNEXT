import { router } from '@kit.ArkUI'
import { PlanTask } from 'exercise'
import { WorkoutPlan } from 'exercise/src/main/ets/bean/WorkoutPlan'

interface ParamsObj {
  workoutPlan: WorkoutPlan
}

class SysRecord {
  public index: number = 0
  public state: string = ''
  public color: string = ''

  constructor(index: number, state: string) {
    this.index = index
    this.state = state
    if(state == 'Completed') this.color = '#a344ab30'
    if(state == 'Pending') this.color = "#c42191fa"
    if(state == 'Abandoned') this.color = '#bac63434'
  }
}

// PlanState: NotStarted Abandoned InProgress Completed

@Entry
@ComponentV2
struct CreatePlanPage {
  @Local workoutPlan: WorkoutPlan = new WorkoutPlan()

  @Local startDate: Date = new Date()
  @Local endDate: Date = new Date()
  @Local dayOfWeek: string = ''
  @Local weekdayIsSelected: boolean[] = [false, false, false, false, false, false, false]
  @Local state: string = ''
  @Local isRecord: boolean = true
  @Local planTasks: PlanTask[] = []

  private weekdaysList: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  private title: string = ''
  private startEndDatePrompt: string = ''
  private workoutDayPrompt: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as ParamsObj
    this.workoutPlan = params.workoutPlan
    if(this.workoutPlan.StartDate instanceof Date)
      this.startDate = this.workoutPlan.StartDate
    if(this.workoutPlan.EndDate instanceof Date)
      this.endDate = this.workoutPlan.EndDate
    for(let i = 0; i < this.workoutPlan.DayOfWeek.length; i += 2)
      this.weekdayIsSelected[(Number(this.workoutPlan.DayOfWeek[i]) + 6) % 7] = true
    if(this.workoutPlan.PlanState != undefined)
      this.state = this.workoutPlan.PlanState
    if(this.state == 'NotStarted') {this.title = '计划创建'; this.startEndDatePrompt = '点击修改起止日期'; this.workoutDayPrompt = '点击选择训练日'}
    else {this.title = '计划详情'; this.startEndDatePrompt = '训练起止日期'; this.workoutDayPrompt = '训练日'}

    this.planTasks = [
      new PlanTask, new PlanTask, new PlanTask, new PlanTask
    ]
    this.planTasks[0].ExecutedDate = new Date(2024, 11, 5)
    this.planTasks[0].State = 'Pending'
    this.planTasks[1].ExecutedDate = new Date(2024, 11, 8)
    this.planTasks[1].State = 'Abandoned'
    this.planTasks[2].ExecutedDate = new Date(2024, 11, 12)
    this.planTasks[2].State = 'Completed'
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_chevron_left'))
          .height(30)
          .onClick(() => {
            router.back()
          })
        Text(this.title)
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

      Scroll() {
        Column() {
          TextInput({
            placeholder: '请输入计划名...',
            text: $$this.workoutPlan.PlanName
          })
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .backgroundColor("#ffeeeeee")
          Row() {
            if(this.workoutPlan.CoverPicture!=undefined)
            Image($r(this.workoutPlan.CoverPicture))
              .height(80)
              .width(80)
              .borderRadius(15)
              .margin({right: 10})
            else
            Row() {
              Text('+')
                .fontSize(56)
                .fontWeight(FontWeight.Lighter)
            }
            .margin({right: 10})
            .backgroundColor(Color.White)
            .width(80)
            .height(80)
            .justifyContent(FlexAlign.Center)
            .borderRadius(20)
            .borderWidth(1)
            .borderColor('#95000000')
            .borderStyle(BorderStyle.Dashed)
            TextArea({
              placeholder: '请输入计划描述...',
              text: $$this.workoutPlan.Description
            })
              .fontSize(14)
              .width(200)
              .fontColor('#b2000000')
              .backgroundColor(Color.White)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .backgroundColor(Color.White)
          .padding(20)
          .borderRadius(10)

          Text(this.startEndDatePrompt)
            .margin({top: 15})
            .fontSize(14)
          Row() {
            Text(this.startDate.toLocaleDateString())
              .fontSize(20)
              .margin({left: 20})
              .fontColor('#ab000000')
              .decoration({ type: TextDecorationType.Underline, color: '#ff2238c4' })
              .onClick(() => {
                if(this.state != 'NotStarted') return
                CalendarPickerDialog.show({
                  selected: this.startDate,
                  onAccept: (value) => {
                    this.startDate = value
                  }
                })
              })

            Text('-')
              .fontSize(18)

            Text(this.endDate.toLocaleDateString())
              .fontSize(20)
              .margin({right: 20})
              .fontColor('#ab000000')
              .decoration({ type: TextDecorationType.Underline, color: '#ff2238c4' })
              .onClick(() => {
                if(this.state != 'NotStarted') return
                CalendarPickerDialog.show({
                  selected: this.endDate,
                  onAccept: (value) => {
                    this.endDate = value
                  }
                })
              })
          }
          .margin({top: 5})
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Text(this.workoutDayPrompt)
            .margin({top: 20})
            .fontSize(14)
          // .backgroundColor('#ff27c5e0')
          // .fontColor(Color.White)
          //.padding({top: 5, bottom: 5, left: 10, right: 10})
          //.borderRadius(10)
          Row() {
            ForEach(this.weekdaysList, (item: string, index) => {
              Text(item)
                .fontSize(14)
                .backgroundColor(this.weekdayIsSelected[index] ? '#007dfe' : Color.White)
                .fontColor(this.weekdayIsSelected[index] ? Color.White : Color.Black)
                .padding({top: 5, bottom: 5, left: 6, right: 6})
                .borderRadius(5)
                .onClick(() => {
                  if(this.state != 'NotStarted') return
                  this.weekdayIsSelected[index] = !this.weekdayIsSelected[index]
                })
            })
          }
          .width('100%')
          .margin({top: 10, bottom: 10})
          .justifyContent(FlexAlign.SpaceBetween)

          exercise()

          if(this.state == 'NotStarted')
          Row() {
            Text('新增动作')
              .fontSize(18)
              .fontColor('#ff005dfe')
          }
          .margin({top: 10})
          .backgroundColor(Color.White)
          .width('100%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .borderRadius(15)
          .borderStyle(BorderStyle.Dashed)
          .borderColor('#007dfe')
          .borderWidth(2)
          .onClick(() => {
            router.pushUrl({
              url: "pages/ActionLibraryPage"
            })
          })

          //显示运动记录
          if(this.state != 'NotStarted')
          Column() {
            Row() {
              Text('历史记录')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .decoration({ type: TextDecorationType.Underline, color: Color.Black })
              Row() {
                Text(this.isRecord ? '系统记录' : '我的记录')
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
                this.isRecord = !this.isRecord
              })
            }
            .margin({top: 20})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({left: 10, right: 10})


            // 日历显示系统记录
            if(this.isRecord)
              Swiper() {
                ForEach(Array.from({length: this.endDate.getMonth() - this.startDate.getMonth() + 1}), (item: number, index) => {
                  Column() {
                    Row() {
                      Text(`${(1 + index + this.startDate.getMonth()).toString()}月`).margin({left: 10})
                        .fontSize(20)
                      Row() {
                        Row().width(14).height(14).borderRadius(7).backgroundColor('#a344ab30')
                        Text('已完成').margin({left: 5})
                        Row().width(14).height(14).borderRadius(7).backgroundColor('#bac63434').margin({left: 5})
                        Text('未完成').margin({left: 5})
                        Row().width(14).height(14).borderRadius(7).backgroundColor("#c42191fa").margin({left: 5})
                        Text('待进行').margin({left: 5, right: 10})
                      }
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                    Grid() {
                      //ForEach(Array.from({length: this.getDaysFromMonth(index + this.startDate.getMonth(), this.startDate.getFullYear())}), (item: number, index) => {
                      ForEach(this.generateMonthlySysRecords(), (item: SysRecord, index) => {
                        GridItem() {
                          Column() {
                            Text((index + 1).toString()).fontColor(item.state == 'None' ? '#80000000' : Color.White)
                          }.height(40).width(40).margin(5).borderWidth(item.state == 'None' ? 1 : 0).borderRadius(20).borderStyle(BorderStyle.Dotted)
                          .justifyContent(FlexAlign.Center)
                          .backgroundColor(item.color)
                        }
                      })
                    }
                    .margin({top: 10})
                    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
                  }
                })
              }
              .margin({top: 20})
              .width('100%')
              .loop(true)
              .borderRadius(10)
              .indicator(false)
              .backgroundColor(Color.White)
              .padding({top: 15, left: 5, right: 5})
              .borderRadius(20)

            else
            Column() {
              Row() {
                Image($r(this.workoutPlan.CoverPicture)).height(60).borderRadius(10)
                Column() {
                  Text('标题')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                  Text('吉萨立刻搭街坊拉萨扩大间发生的纠舍得离开房间阿里山扩大阿斯蒂芬纷爱丽丝的解放拉萨的flask京东方看爱上了京东方')
                    .maxLines(3)
                    .textOverflow({
                      overflow: TextOverflow.Ellipsis
                    })
                    .fontSize(14)
                    .margin({top: 5})
                }
                .margin({left: 15})
                .justifyContent(FlexAlign.SpaceBetween)
                .height('100%')
                .width(220)
                .alignItems(HorizontalAlign.Start)
              }
              .backgroundColor(Color.White)
              .width('100%')
              .padding({left: 15, right: 15, top: 10, bottom: 10})
              .borderRadius(20)
              .height(100)
            }
            .margin({top: 20})
          }

        }
        .height('100%')
        .width('100%')
        .backgroundColor("#ffeeeeee")
        .padding({top: 10, left: 20, right: 20, bottom: 20})
        .alignItems(HorizontalAlign.Center)
      }.height(800).scrollBar(BarState.Off)

    }
  }

  private getDaysFromMonth(month: number, year: number) {
    let days: number[] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    let run: boolean = false
    if(year % 4 == 0) run = true
    if(year % 100 == 0 && year % 400 != 0) run = false
    days[1] += run ? 1 : 0
    return days[month]
  }

  private generateMonthlySysRecords() {
    let ans: SysRecord[] = []
    for(let i: number = 1; i <= 31; i++) {
      if(i == 4) ans.push(new SysRecord(i, 'Pending'))
      else if (i == 10) ans.push(new SysRecord(i, 'Abandoned'))
      else if (i == 18) ans.push(new SysRecord(i, 'Completed'))
      else ans.push(new SysRecord(i, 'None'))
    }
    return ans
  }
}

@ComponentV2
struct exercise {
  @Local exerciseName: string = '卷腹'
  @Local sets: number = 3
  @Local singleSetNum: number = 12
  @Local isEdit: boolean = false
  @Local planState: string = 'NotStarted'

  private setsRange: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
  private setsSelect: number | number[] = this.sets - 1
  private singleSetNumRange: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20']
  private singleSetNumSelect: number | number[] = this.singleSetNum - 1

  build() {
    Column() {
      Row() {
        Image($r('app.media.test_poster1'))
          .height(40)
          .borderRadius(5)
        Column() {
          Text(this.exerciseName)
          Text(`${this.sets} 组  每组${this.singleSetNum}次`)
            .fontSize(14)
            .fontColor('#74000000')
        }
        .alignItems(HorizontalAlign.Start)
        .margin({left: 10})
        Blank()
        if(this.planState == 'NotStarted')
          Image($r('app.media.ic_paintbrush_fill'))
            .height(30)
            .onClick(() => {
              this.isEdit = !this.isEdit
            })
      }
      .width('100%')
      if(this.isEdit)
        Row() {
          Row() {
            Text('组数：')
            Row() {
              Text(this.sets.toString())
            }
            .onClick(() => {
              TextPickerDialog.show({ // 建议使用 this.getUIContext().showTextPickerDialog()接口
                range: this.setsRange,
                selected: this.setsSelect,
                disappearTextStyle: {color: '#54000000', font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                selectedTextStyle: {color: Color.Black, font: {size: 30, weight: FontWeight.Bold}},
                onAccept: (value: TextPickerResult) => {
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  this.setsSelect = value.index
                  this.sets = Number(value.value as string)
                }
              })
            })
            .width(70)
            .height(34)
            .borderRadius(17)
            .borderWidth(1)
            .borderColor(Color.Black)
            .justifyContent(FlexAlign.Center)
          }
          Row() {
            Text('每组次数：')
            Row() {
              Text(this.singleSetNum.toString())
            }
            .onClick(() => {
              TextPickerDialog.show({ // 建议使用 this.getUIContext().showTextPickerDialog()接口
                range: this.singleSetNumRange,
                selected: this.singleSetNumSelect,
                disappearTextStyle: {color: '#54000000', font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                selectedTextStyle: {color: Color.Black, font: {size: 30, weight: FontWeight.Bold}},
                onAccept: (value: TextPickerResult) => {
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  this.singleSetNumSelect = value.index
                  this.singleSetNum = Number(value.value as string)
                }
              })
            })
            .width(70)
            .height(34)
            .borderRadius(17)
            .borderWidth(1)
            .borderColor(Color.Black)
            .justifyContent(FlexAlign.Center)
          }
          .margin({left: 10})

        }
        .margin({top: 10})
    }
    .backgroundColor(Color.White)
    .width('100%')
    .borderRadius(10)
    .padding(10)
    .margin({top: 10})
  }
}

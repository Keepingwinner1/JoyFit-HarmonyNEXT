import { router } from '@kit.ArkUI'
import { WorkoutPlan } from 'exercise/src/main/ets/bean/WorkoutPlan'

interface ParamsObj {
  workoutPlan: WorkoutPlan
}

@Entry
@ComponentV2
struct CreatePlanPage {
  @Local workoutPlan: WorkoutPlan = new WorkoutPlan()

  @Local startDate: Date = new Date()
  @Local endDate: Date = new Date()
  @Local dayOfWeek: string = ''
  @Local weekdayIsSelected: boolean[] = [false, false, false, false, false, false, false]

  private weekdaysList: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']


  aboutToAppear(): void {
    const params = router.getParams() as ParamsObj
    this.workoutPlan = params.workoutPlan
    if(this.workoutPlan.StartDate instanceof Date)
      this.startDate = this.workoutPlan.StartDate
    if(this.workoutPlan.EndDate instanceof Date)
      this.endDate = this.workoutPlan.EndDate
    for(let i = 0; i < this.workoutPlan.DayOfWeek.length; i += 2)
      this.weekdayIsSelected[(Number(this.workoutPlan.DayOfWeek[i]) + 6) % 7] = true
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_chevron_left'))
          .height(30)
          .onClick(() => {
            router.back()
          })
        Text('计划创建')
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

      Column() {
        TextInput({
          placeholder: '请输入计划名...',
          text: $$this.workoutPlan.PlanName
        })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#ffeeeeee")
        Row() {
          Image($r(this.workoutPlan.CoverPicture))
            .height(80)
            .width(80)
            .borderRadius(15)
            .margin({right: 10})
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

        Text('点击修改起止日期')
          .margin({top: 15})
          .fontSize(14)
        Row() {
          Text(this.startDate.toLocaleDateString())
            .fontSize(20)
            .margin({left: 20})
            .fontColor('#ab000000')
            .decoration({ type: TextDecorationType.Underline, color: '#ff2238c4' })
            .onClick(() => {
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

        Text('点击选择训练日')
          .margin({top: 20})
          .backgroundColor('#ff27c5e0')
          .fontColor(Color.White)
          .padding({top: 5, bottom: 5, left: 10, right: 10})
          .borderRadius(10)
        Row() {
          ForEach(this.weekdaysList, (item: string, index) =>{
            Text(item)
              .fontSize(14)
              .backgroundColor(this.weekdayIsSelected[index] ? '#007dfe' : Color.White)
              .fontColor(this.weekdayIsSelected[index] ? Color.White : Color.Black)
              .padding({top: 5, bottom: 5, left: 6, right: 6})
              .borderRadius(5)
              .onClick(() => {
                this.weekdayIsSelected[index] = !this.weekdayIsSelected[index]
              })
          })
        }
        .width('100%')
        .margin({top: 10, bottom: 10})
        .justifyContent(FlexAlign.SpaceBetween)

        exercise()

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
      }
      .height('100%')
      .width('100%')
      .backgroundColor("#ffeeeeee")
      .padding({top: 10, left: 20, right: 20, bottom: 20})
      .alignItems(HorizontalAlign.Center)
    }
  }
}

@ComponentV2
struct exercise {
  @Local exerciseName: string = '卷腹'
  @Local sets: number = 3
  @Local singleSetNum: number = 12
  @Local isEdit: boolean = false

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
          Button(this.sets.toString())
            .onClick(() => {
              TextPickerDialog.show({ // 建议使用 this.getUIContext().showTextPickerDialog()接口
                range: this.setsRange,
                selected: this.setsSelect,
                disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
                onAccept: (value: TextPickerResult) => {
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  this.setsSelect = value.index
                  this.sets = Number(value.value as string)
                }
              })
            })
            .width(70)
        }
        Row() {
          Text('每组次数：')
          Button(this.singleSetNum.toString())
            .onClick(() => {
              TextPickerDialog.show({ // 建议使用 this.getUIContext().showTextPickerDialog()接口
                range: this.singleSetNumRange,
                selected: this.singleSetNumSelect,
                disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
                onAccept: (value: TextPickerResult) => {
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  this.singleSetNumSelect = value.index
                  this.singleSetNum = Number(value.value as string)
                }
              })
            })
            .width(70)
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

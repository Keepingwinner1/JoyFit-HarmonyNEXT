import { router } from '@kit.ArkUI'

class exercise {
  imageUrl: string = ''
  name: string = ''
  time: number = 0

  constructor(imageUrl: string, name: string, time: number) {
    this.imageUrl = imageUrl
    this.name = name
    this.time = time
  }
}



@Entry
@ComponentV2
struct ActionLibraryPage {
  @Local selectedItem: number = 0

  private trainingPartList: string[] = ['胸', '背', '肩', '手臂', '腹部', '腿']
  private exerciseList: exercise[] = [new exercise('app.media.test_exercise_item', '卷腹', 20)]

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_chevron_left'))
          .height(30)
          .onClick(() => {
            router.back()
          })
        Text('动作库')
        Image($r('app.media.ic_plus_square'))
          .height(30)
          .onClick(() => {
            router.pushUrl({
              url: "pages/AddActionPage"
            })
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: 30, right: 30})

      Row() {
        Column() {
          ForEach(this.trainingPartList, (item: string, index) => {
            trainingPartItem({
              isSelected: this.selectedItem == index ? true : false,
              trainingPartName: item
            })
              .onClick(() => {
                this.selectedItem = index
              })
          })
        }
        .height('100%')
        .backgroundColor('#fff5f5f5')

        Column() {
          ForEach(this.exerciseList, (item: exercise, index) => {
            exerciseItem({
              imageUrl: item.imageUrl,
              name: item.name,
              time: item.time
            })
          })
        }
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .padding({top: 20})
    }

  }
}

@ComponentV2
struct trainingPartItem {
  @Param isSelected: boolean = false
  @Param trainingPartName: string = ''

  build() {
    Row() {
      Column().height('100%').width(5).backgroundColor(this.isSelected ? '#007dfe' : '#fff5f5f5').margin({right: 12})
      Text(this.trainingPartName)
        .fontColor(this.isSelected ? '#007dfe' : Color.Black)
        .fontSize(16)
    }
    .height(50)
    .width(85)
    .backgroundColor(this.isSelected ? Color.White : '#fff5f5f5')
  }
}

@ComponentV2
struct exerciseItem {
  @Param imageUrl: string = ''
  @Param name: string = ''
  @Param time: number = 0

  build() {
    Row() {
      Image($r(this.imageUrl))
        .height(70)
        .borderRadius(10)
      Column() {
        Text(this.name)
        Text(`${this.time.toString()}min`)
          .fontSize(14)
          .fontColor('#66000000')
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .margin({left: 10})
    }
    .width('100%')
    .height(80)
    .padding(10)
  }
}

import MinePage from '../view/MinePage'
import PlanPage from '../view/PlanPage'
import SportsDataPage from '../view/SportsDataPage'

@Entry
@ComponentV2
struct MainPage {
  @Local selectedIndex: number = 0

  build() {
    Tabs({barPosition: BarPosition.End}) {
      TabContent() {
        SportsDataPage()
      }
      .tabBar(this.myTabBar(0, '运动', $r('app.media.ic_figure_running')))
      TabContent() {
        PlanPage()
      }
      .tabBar(this.myTabBar(1, '计划', $r('app.media.ic_list_bullet')))
      TabContent() {
        MinePage()
      }
      .tabBar(this.myTabBar(2, '我的', $r('app.media.ic_house_fill')))
    }
    .scrollable(true)
    .onChange((index: number) => {
      this.selectedIndex = index
    })
  }

  @Builder
  myTabBar(itemIndex: number, title: string, image: Resource) {
    Column() {
      Image(image)
        .width(20)
        .fillColor(itemIndex == this.selectedIndex ? Color.Black : '#6d000000')
      Text(title)
        .fontColor(itemIndex == this.selectedIndex ? Color.Black : '#6d000000')
        .fontSize(12)
        .margin({top: 5})
    }
    .margin({top: 8})
  }
}

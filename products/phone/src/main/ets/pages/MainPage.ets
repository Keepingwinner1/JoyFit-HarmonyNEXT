//todo
// 创建动作：新增动作备注；修改图片为视频，增加动作时间，载加个textinput输入用户需求（文字形式）；音频创建AI：参考豆包，允许切换模板，或者直接输入；对接收的音频预览、删除重建
// 查看动作详情：
// 动作库：添加区分官方动作和自定义动作
// 开始运动：增加动作备注
// 我的页：展示年龄性别所在地（图标）；加体质表，加bmi、体脂历史数据展示
// 计划页：按钮切换跑步计划和锻炼计划，放在轮播图下
// 查看计划记录：点击正在执行和历史计划，查看记录：日期和训练日放在详情介绍卡片内，显示动作，不能新增
// 记录：按钮切换记录和帖子，todo
// 跑步计划：做静态页面
// 成就和完成动作后，分享图片


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

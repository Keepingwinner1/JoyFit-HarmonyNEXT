import { Route, ZRouter } from "@hzw/zrouter";
import { CommonConst, NavName } from "utils";


/**
 * Describe: 启动页
 */
@Preview
@ComponentV2
@Route({ name: NavName.SPLASH_PAGE })
export struct SplashPage {
  aboutToAppear(): void {
    // 跳转到登录页面
    // ZRouter.getInstance().navigation(NavName.LOGIN_VIEW)
    // 跳转到主页面
    //ZRouter.getInstance().navigation(NavName.MAIN_PAGE)

    // 测试
    ZRouter.getInstance().removeByName(NavName.TEST_VIEW)
  }

  build() {
    NavDestination() {

    }.hideTitleBar(true)
    .width(CommonConst.FULL_PARENT)
    .height(CommonConst.FULL_PARENT)
  }
}

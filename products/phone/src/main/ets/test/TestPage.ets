import { Route, ZRouter } from "@hzw/zrouter";
import { NavName } from "utils";

@ComponentV2
@Route({ name: NavName.TEST_VIEW })
export struct TestPage {
  @Local message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('TestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}

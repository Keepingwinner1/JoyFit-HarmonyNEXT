import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface IdGeneratorResponse {
  uuid: string
}

@Entry
@Component
struct CloudFunction {
  @State globalId: string = '';

  build() {
    Column({ space: 20 }) {
      Navigation()
        .title($r('app.string.cloud_function_title'))
        .height('50vp')
        .width('100%')
        .titleMode(NavigationTitleMode.Mini)
      Text($r('app.string.cloud_function_description'))
        .width('90%')
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.body_font_size'))
      Button($r('app.string.cloud_function_button_text'), { type: ButtonType.Normal })
        .width('90%')
        .height(40)
        .borderRadius(4)
        .onClick(() => {
          this.callIdGenerator();
        })

      Column() {
        Text(this.globalId).fontSize($r('app.float.body_font_size'))
          .fontColor($r('app.color.body_color'))
          .height('100%')
      }
      .width('90%')
      .height(40)
      .borderWidth(1)
      .borderRadius(4)
      .borderColor($r('app.color.body_color'))
    }
  }

  private callIdGenerator() {
    cloudFunction.call({ name: 'id-generator' }).then((res: cloudFunction.FunctionResult) => {
      this.globalId = (res.result as IdGeneratorResponse).uuid;
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'CloudFunction', 'call id-generator exception, ErrCode: %{public}d ErrMessage: %{public}s',
        err.code, err.message);
    });
  }
}

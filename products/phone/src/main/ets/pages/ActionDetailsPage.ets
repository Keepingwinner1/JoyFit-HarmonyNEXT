import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct ActionDetailsPage {
  @Local isCreatingAudio: boolean = false
  @Local maskOpacity: number = 0
  @Local text1: string = ''
  @Local text2: string = ''
  @Local isPlaying: boolean = false

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.ic_chevron_left'))
            .height(30)
            .onClick(() => {
              router.back()
            })
          Text('动作库').fontColor(Color.White)
          Image($r('app.media.ic_plus_square'))
            .height(30)
            .fillColor(Color.White)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left: 30, right: 30, bottom: 10})

        Image($r('app.media.test_exercise_item')).width('100%').height(250)

        Text('靠墙站').width('100%').fontSize(26).fontWeight(FontWeight.Bold).margin({top: 20, left: 30})

        Row() {
          Text('部位：').fontColor('#9a000000')
          Text('全身').margin({left: 10})
        }.margin({top: 20, left: 30}).width('100%')
        Text('要点：').margin({top: 20, left: 30}).width('100%').fontColor('#9a000000')
        Text('ask决定恢复卡死哈哈啥的看法hash看记得发货凯撒话费卡适当放宽撒娇回复卡的好看收到回复喀什Sakhalin客户库哈斯肯定会饭卡上好地方看会电视打开话费卡是的饭卡上俯瞰暗杀士大夫收到反馈首付款金沙江开发上雕刻技法哈萨克等级划分啊开始发开始哈萨克符合客户')
          .margin({top: 10, left: 30, right: 30})

        Blank()

        //Image($r('app.media.ic_wave')).height(180)

        Column() {
          Text('生成AI智能语音指导').fontColor(Color.White).fontSize(18).fontWeight(FontWeight.Bold)
        }
        .backgroundColor("#0bbe86")
        .padding({top: 10, bottom: 10, left: 20, right: 20})
        .borderRadius(20)
        .onClick(() => {
          this.isCreatingAudio = !this.isCreatingAudio
          this.maskOpacity = 1
        })

      }.width('100%').height('100%')

      Column() {
        Column() {
          Row() {
            Text('提示词一')
            TextInput({
              placeholder: '请输入',
              text: $$this.text1
            })
              .backgroundColor(Color.White)
              .width(150)
          }
          Row() {
            Text('提示词一')
            TextInput({
              placeholder: '请输入',
              text: $$this.text1
            })
              .backgroundColor(Color.White)
              .width(150)
          }
          Row() {
            Text('提示词一')
            TextInput({
              placeholder: '请输入',
              text: $$this.text1
            })
              .backgroundColor(Color.White)
              .width(150)
          }

          Button('完成')
            .onClick(() => {
              this.isCreatingAudio = !this.isCreatingAudio
              this.maskOpacity = 0
            })
        }
        .backgroundColor(Color.White)
        .height(300)
        .width(280)
        .borderRadius(20)
        .padding(20)
        .margin({top: 150})
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ce000000')
      .zIndex(this.isCreatingAudio ? 5 : -1)
      //.justifyContent(FlexAlign.Center)
      .opacity(this.maskOpacity)
      .animation({
        duration: 300
      })
      // .onClick(() => {
      //   this.isCreatingAudio = !this.isCreatingAudio
      //   this.maskOpacity = 0
      // })
    }

  }
}

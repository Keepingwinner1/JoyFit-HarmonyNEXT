import { actionBuilder } from "./actionBuilder";
import { action } from "./action";



export class ActionFactory {

  //胸部
  public static createChestAction(): action {
    return new actionBuilder("Chest")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与胸部肌群有关的动作")
      .build();
  }

  //背部
  public static createBackAction(): action {
    return new actionBuilder("Back")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与背部肌群有关的动作")
      .build();
  }

  //肩部
  public static createShouldersAction(): action {
    return new actionBuilder("Shoulders")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与肩部肌群有关的动作")
      .build();
  }

  //手臂
  public static createArmsAction(): action {
    return new actionBuilder("Arms")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与手臂肌群有关的动作")
      .build();
  }

  //腿部
  public static createLegAction(): action {
    return new actionBuilder("Leg")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与腿部肌群有关的动作")
      .build();
  }

  //腹部
  public static createAbdomenAction(): action {
    return new actionBuilder("Abdomen")
      .sets(3)
      .singleSetNum(10)
      .description("")
      .timeOfOne(30)
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .note("这是一个与腹部肌群有关的动作")
      .build();
  }

}

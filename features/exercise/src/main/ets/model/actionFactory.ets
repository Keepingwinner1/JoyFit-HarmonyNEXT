import { actionBuilder } from "./actionBuilder";
import { action } from "./action";



export class ActionFactory {

  public static createRunningAction(): action {
    return new actionBuilder("Running")
      .sets(3)
      .singleSetNum(10)
      .description("轻度热身动作，提升心率和关节活动度")
      .timeOfOne(30)
      .mainTrainingPart("")
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .build();
  }

  public static createWorkoutAction(): action {
    return new actionBuilder("Workout")
      .sets(4)
      .singleSetNum(15)
      .description("力量训练动作，提高肌肉耐力和力量")
      .timeOfOne(60)
      .mainTrainingPart("")
      .isUserDefined(false)
      .introductionVideo("")
      .introductionVoice("")
      .build();
  }

}

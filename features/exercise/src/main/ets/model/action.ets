import { Action } from "../bean/Action";
import { PlanAction } from "../bean/PlanAction";

export class actionInfo{
  public ActionName: string | undefined;  // String类型
  public ActonType: string | undefined;  // String类型
  public Sets: number | undefined;  // Integer类型
  public SingleSetNum: number | undefined;  // Integer类型

  constructor(ActionName: string | undefined, ActonType: string | undefined, Sets: number | undefined, SingleSetNum: number | undefined) {
    this.ActionName = ActionName;
    this.ActonType = ActonType;
    this.Sets = Sets;
    this.SingleSetNum = SingleSetNum;
  }

}

export class action {
  public basicInfo : actionInfo| undefined;
  public IntroductionVideo: string | undefined;  // String类型
  public IntroductionVoice: string | undefined;  // String类型
  public Description: string | undefined;  // Text类型
  public TimeOfOne: number | undefined;  // Integer类型
  public MainTrainingPart: string | undefined;  // String类型
  public IsUserDefined: boolean | undefined;  // Boolean类型

  constructor(
    basicInfo?: actionInfo,
    IntroductionVideo?: string,
    IntroductionVoice?: string,
    Description?: string,
    TimeOfOne?: number,
    MainTrainingPart?: string,
    IsUserDefined?: boolean
  ) {
    this.basicInfo = basicInfo;
    this.IntroductionVideo = IntroductionVideo;
    this.IntroductionVoice = IntroductionVoice;
    this.Description = Description;
    this.TimeOfOne = TimeOfOne;
    this.MainTrainingPart = MainTrainingPart;
    this.IsUserDefined = IsUserDefined;
  }

  public static createFromAction(input1:Action,input2:PlanAction): action{
    let basicInfo = new actionInfo(input1.ActionName,input1.ActonType,input2.Sets,input2.SingleSetNum);
    return new action(basicInfo,input1.IntroductionVideo,input1.IntroductionVoice,input1.Description,input1.TimeOfOne,input1.MainTrainingPart,input1.IsUserDefined)
  }

}



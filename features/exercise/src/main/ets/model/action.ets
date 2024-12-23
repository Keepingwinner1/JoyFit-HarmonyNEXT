import { Action } from "../bean/Action";
import { PlanAction } from "../bean/PlanAction";

export class actionInfo{
  public ActionName: string ='';  // String类型
  public ActionID: string | undefined;  // Integer类型
  public Sets: number = 0;  // Integer类型
  public SingleSetNum: number = 0;  // Integer类型

  constructor(ActionName: string , ActionID: string | undefined, Sets: number, SingleSetNum: number ) {
    this.ActionName = ActionName;
    this.ActionID =ActionID;
    this.Sets = Sets;
    this.SingleSetNum = SingleSetNum;
  }

}

export class action {
  public basicInfo : actionInfo;
  public IntroductionVideo: string | undefined;  // String类型
  public IntroductionVoice: string | undefined;  // String类型
  public Note:string | undefined;//动作备注，按照文档上的数据库表进行修改，于12.21修改
  public Description: string ='';  // String类型
  public TimeOfOne: number = 0;  // Integer类型
  public MainTrainingPart: string ='';  // String类型，有Chest(胸) Back（背） Shoulders（肩） Arms（手臂） Abdomen（腹） Leg（腿）
  public IsUserDefined: boolean =false;  // Boolean类型
  public Calories: number =0;

  constructor(
    basicInfo: actionInfo,
    IntroductionVideo: string,
    IntroductionVoice: string,
    Description: string,
    TimeOfOne: number,
    MainTrainingPart: string,
    IsUserDefined: boolean,
    Calories:number,
    Note:string
  ) {
    this.basicInfo = basicInfo;
    this.IntroductionVideo = IntroductionVideo;
    this.IntroductionVoice = IntroductionVoice;
    this.Description = Description;
    this.TimeOfOne = TimeOfOne;
    this.MainTrainingPart = MainTrainingPart;
    this.IsUserDefined = IsUserDefined;
    this.Calories =Calories;
    this.Note=Note;
  }

  public static createFromAction(input1:Action,input2:PlanAction): action | null {
    if(input1.ActionName != undefined && input2.Sets !=undefined && input2.SingleSetNum != undefined ){
      let basicInfo = new actionInfo(input1.ActionName,input1.ActionID,input2.Sets,input2.SingleSetNum);
      if(input1.IntroductionVoice!=undefined && input1.IntroductionVideo!=undefined && input1.Description!= undefined && input1.TimeOfOne!=undefined && input1.MainTrainingPart!=undefined&& input1.IsUserDefined && input1.Carlories&&input1.Note!=undefined)
        return new action(basicInfo,input1.IntroductionVideo,input1.IntroductionVoice,input1.Description,input1.TimeOfOne,input1.MainTrainingPart,input1.IsUserDefined,input1.Carlories,input1.Note);
      else
        return null;
    }
    else
      return null;
  }

}



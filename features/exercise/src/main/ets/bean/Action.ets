import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个Action的类继承cloudDatabase.DatabaseObject
class Action extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'Action';
  }

  public ActionID: string | undefined;  // Integer类型
  public ActionName: string | undefined;  // String类型
  public ActonType: string | undefined;  // String类型
  public IntroductionVideo: string | undefined ;  // String类型
  public IntroductionVoice: string | undefined;  // String类型
  public Description: string | undefined;  // Text类型
  public TimeOfOne: number | undefined;  // Integer类型
  public MainTrainingPart: string | undefined ;  // String类型
  public IsUserDefined: boolean | undefined;  // Boolean类型
  public Carlories: number|undefined;

}

export { Action };

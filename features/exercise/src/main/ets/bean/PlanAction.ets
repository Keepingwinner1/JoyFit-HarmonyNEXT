import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个PlanAction的类继承cloudDatabase.DatabaseObject
class PlanAction extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'PlanAction';
  }

  public PlanID: string | undefined;  // Integer类型
  public ActionID: string | undefined;  // Integer类型
  public Sets: number | undefined;  // Integer类型
  public SingleSetNum: number | undefined;  // Integer类型
}

export { PlanAction };

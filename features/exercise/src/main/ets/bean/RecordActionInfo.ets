import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个PlanAction的类继承cloudDatabase.DatabaseObject
class RecordActionInfo extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'RecordActionInfo';
  }

  public RecordActionInfoID: string | undefined;  // Integer类型
  public RecordID: string | undefined;  // Integer类型
  public ActionID: string | undefined;  // Integer类型
  public Sets: number | undefined;  // Integer类型
}

export { RecordActionInfo };

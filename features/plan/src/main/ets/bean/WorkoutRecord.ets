import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个WorkoutRecord的类继承cloudDatabase.DatabaseObject
class WorkoutRecord extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'WorkoutRecord';
  }

  public WorkoutRecordID: string | undefined;  // String类型
  public RecordID: string | undefined;  // String类型
  public ActionInfoID: string | undefined;  // String类型
}

export { WorkoutRecord };

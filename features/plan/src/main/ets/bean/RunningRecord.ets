import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个RunningRecord的类继承cloudDatabase.DatabaseObject
class RunningRecord extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'RunningRecord';
  }

  public RecordID: string | undefined;  // string类型
  public Speed: number | undefined;  // Double类型
  public Miles: number | undefined;  // Double类型
  public TotalTime: number | undefined;  // Double类型
  public Location: string | undefined;  // String类型
  public Trajectory: string | undefined;  // String类型
}

export { RunningRecord };

import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个RunningRecord的类继承cloudDatabase.DatabaseObject
class RunningRecord extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'RunningRecord';
  }
  public RecordID: string | undefined;  // Integer类型
  public Image: string | undefined;  // String类型
  public Feeling: string | undefined;  // Text类型
  public RecordDate: Date | undefined;  // Date类型
  public Calories: number | undefined;  // Double类型
  public PlanID: number | undefined;  // Integer类型
  public Speed: number | undefined;  // Double类型
  public Miles: number | undefined;  // Double类型
  public TotalTime: number | undefined;  // Double类型
  public Location: string | undefined;  // String类型
}

export { RunningRecord };

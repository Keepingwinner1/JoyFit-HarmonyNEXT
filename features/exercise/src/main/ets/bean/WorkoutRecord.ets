import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个WorkoutRecord的类继承cloudDatabase.DatabaseObject
class WorkoutRecord extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'WorkoutRecord';
  }

  public RecordID: string | undefined;  // Integer类型
  public Image: string | undefined;  // String类型
  public Feeling: string | undefined;  // Text类型
  public RecordDate: Date | undefined;  // Date类型
  public Calories: number | undefined;  // Double类型
  public PlanID: number | undefined;  // Integer类型
  public State: string |undefined;
}

export { WorkoutRecord };

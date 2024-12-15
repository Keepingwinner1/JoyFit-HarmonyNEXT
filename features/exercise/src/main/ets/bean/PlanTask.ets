import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个PlanTask的类继承cloudDatabase.DatabaseObject
class PlanTask extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'PlanTask';
  }

  public TaskID: string | undefined;  // String类型
  public UserID: string |undefined;
  public PlanID: string | undefined;  // String类型
  public ExecutedDate: Date | undefined;  // Date类型
  public State: string | undefined;  // String类型
  public TaskType: string |undefined;

}

export { PlanTask };

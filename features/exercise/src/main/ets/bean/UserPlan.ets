import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个UserPlan的类继承cloudDatabase.DatabaseObject
class UserPlan extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'UserPlan';
  }
  public PlanID: string | undefined;  // String类型
  public UserID: string | undefined;  // String类型
}

export { UserPlan };

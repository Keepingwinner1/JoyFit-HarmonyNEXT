import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个RunningPlan的类继承cloudDatabase.DatabaseObject
class RunningPlan extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'RunningPlan';
  }

  public PlanID: string | undefined;  // Integer类型
  public GoalOfTotalTime: number | undefined;  // Integer类型
  public GoalOfTotalMiles: number | undefined;  // Integer类型
  public GoalOfSpeed: number | undefined;  // Integer类型
}

export { RunningPlan };

import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个ExercisePlan的类继承cloudDatabase.DatabaseObject
class ExercisePlan extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'ExercisePlan';
  }

  public PlanID: string | undefined;  // Integer类型
  public PlanName: string | undefined;  // String类型
  public CoverPicture: string | undefined;  // String类型
  public PlanType: string | undefined;  // String类型
  public PlanState: string | undefined;  // String类型
  public Weeks: number | undefined;  // Integer类型
  public DayOfWeek: string | undefined;  // String类型
  public StartDate: Date | undefined;  // Date类型
  public ExecutionProgress: number | undefined;  // Double类型
}

export { ExercisePlan };

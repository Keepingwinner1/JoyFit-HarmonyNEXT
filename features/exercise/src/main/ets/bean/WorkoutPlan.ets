import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个WorkoutPlan的类继承cloudDatabase.DatabaseObject
class WorkoutPlan extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'WorkoutPlan';
  }

  public PlanID: string | undefined;  // Integer类型
  public UserID: string | undefined;  // String类型
  public PlanName: string | undefined;  // String类型
  public CoverPicture: string | undefined;  // String类型
  public PlanState: string | undefined;  // String类型
  public EndDate: Date | undefined;  // Integer类型
  public DayOfWeek: string | undefined;  // String类型
  public StartDate: Date | undefined;  // Date类型
  public RestTimeBetweenSets: number | undefined;  // Integer类型
  public RestTimeBetweenExercises: number | undefined;  // Integer类型
  public TotalTime: number | undefined;
  public Description: string | undefined;
  public Tag: string | undefined;
}

export { WorkoutPlan };

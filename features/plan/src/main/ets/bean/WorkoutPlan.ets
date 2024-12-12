import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个WorkoutPlan的类继承cloudDatabase.DatabaseObject
class WorkoutPlan extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'WorkoutPlan';
  }

  public PlanID: string | undefined;  // string类型
  public RestTimeBetweenSets: number | undefined;  // Integer类型
  public RestTimeBetweenExercises: number | undefined;  // Integer类型
}

export { WorkoutPlan };

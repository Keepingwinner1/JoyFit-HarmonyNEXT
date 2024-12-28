import { cloudDatabase } from '@kit.CloudFoundationKit';

export class ExerciseStates extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'ExerciseStates';
  }
  public UserID : string | undefined;
  public TimeStamp : number | undefined;
  public TotalSteps : number| undefined;
  public TotalExerciseTime: number | undefined;
  public TotalCaloriesBurned: number | undefined;


}

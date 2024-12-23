import { workoutPlan } from './workoutPlan';
import { PlanBuilder} from './planBuilder'

export class workoutPlanBuilder extends PlanBuilder {
  public RestTimeBetweenSets: number = 5;
  public RestTimeBetweenExercises: number = 10;
  public TotalTime: number =0;

  constructor(){
    super();
  }

  // 设置 RestTimeBetweenSets
  public setRestTimeBetweenSets(RestTimeBetweenSets: number): workoutPlanBuilder {
    this.RestTimeBetweenSets = RestTimeBetweenSets;
    return this;
  }

  // 设置 RestTimeBetweenExercises
  public setRestTimeBetweenExercises(RestTimeBetweenExercises: number): workoutPlanBuilder {
    this.RestTimeBetweenExercises = RestTimeBetweenExercises;
    return this;
  }

  public setTotalTime(TotalTime: number): workoutPlanBuilder{
    this.TotalTime =TotalTime;
    return this;
  }

  // 创建 WorkoutPlan 实例
  build(): workoutPlan {
    return new workoutPlan(this);
  }
}


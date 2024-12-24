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

  private isToday(date: Date): boolean{
    const now = new Date();
    // 清零时间部分
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
    const startOfTomorrow = startOfToday + 24 * 60 * 60 * 1000; // 今天午夜 + 1 天
    // 获取目标日期的时间戳
    const targetTime = date.getTime();
    return targetTime >= startOfToday && targetTime < startOfTomorrow;
  }

  // 创建 WorkoutPlan 实例
  build(): workoutPlan {
    if(this.isToday(this.StartDate))
        this.PlanState = "InProgress";
    return new workoutPlan(this);
  }
}


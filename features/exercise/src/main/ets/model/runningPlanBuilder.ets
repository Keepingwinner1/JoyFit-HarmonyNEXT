import { runningPlan } from "./runningPlan";
import { PlanBuilder } from "./planBuilder";


export class runningPlanBuilder extends PlanBuilder {
  public GoalOfTotalTime: number | undefined;
  public GoalOfTotalMiles: number | undefined;
  public GoalOfSpeed: number | undefined;

  // 设置 GoalOfTotalTime
  setGoalOfTotalTime(GoalOfTotalTime: number): runningPlanBuilder {
    this.GoalOfTotalTime = GoalOfTotalTime;
    return this;
  }

  // 设置 GoalOfTotalMiles
  setGoalOfTotalMiles(GoalOfTotalMiles: number): runningPlanBuilder {
    this.GoalOfTotalMiles = GoalOfTotalMiles;
    return this;
  }

  // 设置 GoalOfSpeed
  setGoalOfSpeed(GoalOfSpeed: number): runningPlanBuilder {
    this.GoalOfSpeed = GoalOfSpeed;
    return this;
  }

  // 创建 RunningPlan 实例
  build(): runningPlan {
    return new runningPlan(this);
  }
}

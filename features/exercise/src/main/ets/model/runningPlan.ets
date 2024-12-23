import {runningPlanBuilder} from './runningPlanBuilder'
import {exercisePlan} from'./exercisePlan'

export class runningPlan extends exercisePlan{
  public GoalOfTotalTime: number | undefined;
  public GoalOfTotalMiles: number | undefined;
  public GoalOfSpeed: number | undefined;

  constructor(builder: runningPlanBuilder) {
    super(builder);
    this.GoalOfTotalTime = builder.GoalOfTotalTime;
    this.GoalOfTotalMiles = builder.GoalOfTotalMiles;
    this.GoalOfSpeed = builder.GoalOfSpeed;
  }
}


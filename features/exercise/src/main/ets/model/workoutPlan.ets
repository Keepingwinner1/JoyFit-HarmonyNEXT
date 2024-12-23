import {workoutPlanBuilder} from './workoutPlanBuilder'
import {exercisePlan} from'./exercisePlan'

export class workoutPlan extends exercisePlan{
  public RestTimeBetweenSets: number = 5;
  public RestTimeBetweenExercises: number = 20;
  public TotalTime: number = 0;

  constructor(builder: workoutPlanBuilder) {
    super(builder);
    this.RestTimeBetweenSets = builder.RestTimeBetweenSets;
    this.RestTimeBetweenExercises = builder.RestTimeBetweenExercises;
    this.TotalTime =builder.TotalTime;
  }

}


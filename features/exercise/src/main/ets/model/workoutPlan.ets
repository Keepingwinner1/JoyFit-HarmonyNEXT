import {workoutPlanBuilder} from './workoutPlanBuilder'
import {exercisePlan} from'./exercisePlan'

export class workoutPlan extends exercisePlan{
  public RestTimeBetweenSets: number | undefined;
  public RestTimeBetweenExercises: number | undefined;

  constructor(builder: workoutPlanBuilder) {
    super();
    this.RestTimeBetweenSets = builder.RestTimeBetweenSets;
    this.RestTimeBetweenExercises = builder.RestTimeBetweenExercises;
  }

}


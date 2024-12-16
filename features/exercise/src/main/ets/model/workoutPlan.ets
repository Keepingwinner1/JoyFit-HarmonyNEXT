import {workoutPlanBuilder} from './workoutPlanBuilder'
import {exercisePlan} from'./exercisePlan'

export class workoutPlan extends exercisePlan{
  public RestTimeBetweenSets: number = 5;
  public RestTimeBetweenExercises: number = 20;

  constructor(builder: workoutPlanBuilder) {
    super();
    this.RestTimeBetweenSets = builder.RestTimeBetweenSets;
    this.RestTimeBetweenExercises = builder.RestTimeBetweenExercises;
  }

}


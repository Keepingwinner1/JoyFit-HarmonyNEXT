import {ExercisePlanService} from '../service/ExercisePlanService'
import {WorkoutPlan} from'../bean/WorkoutPlan'
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { workoutPlan } from'../model/workoutPlan'
import { UserPlan } from '../bean/UserPlan';
import { exercisePlan } from '../model/exercisePlan';

export class WorkoutPlanService extends ExercisePlanService {

  private static instance: WorkoutPlanService | null = null;

  private constructor() {
    super();
  }

  public static getInstance(): WorkoutPlanService{
    if (!WorkoutPlanService.instance) {
      WorkoutPlanService.instance = new  WorkoutPlanService();
    }
    return  WorkoutPlanService.instance;
  }

  private ToBean(plan:workoutPlan){
    let planContent =new WorkoutPlan();
    planContent.PlanID = plan.PlanID;
    planContent.PlanName =plan.PlanName;
    planContent.CoverPicture =plan.CoverPicture;
    planContent.PlanState =plan.PlanState;
    planContent.EndDate =plan.EndDate;
    planContent.DayOfWeek =plan.DayOfWeek;
    planContent.StartDate =plan.StartDate;
    planContent.ExecutionProgress =plan.ExecutionProgress;
    planContent.RestTimeBetweenSets = plan.RestTimeBetweenSets;
    planContent.RestTimeBetweenExercises =plan.RestTimeBetweenExercises;
    return planContent;
  }

  public async uploadPlan(plan:workoutPlan,userID:string): Promise<boolean> {
     //向UserPlan、WorkoutPlan表中插入记录
      let userPlan: UserPlan =new UserPlan();
      userPlan.PlanID =plan.PlanID;
      userPlan.UserID =userID;
      const planContent =this.ToBean(plan);
      try {
        await this.agcDataBase?.upsert(userPlan);
        await this.agcDataBase?.upsert(planContent);
        return true;
      } catch (err) {
        return false;
      }
  }

  public async updatePlan(plan: workoutPlan, userID: string): Promise<boolean> {
    const planContent =this.ToBean(plan);
    try {
      await this.agcDataBase?.upsert(planContent);
      return true;
    } catch (err) {
      return false;
    }
  }

  public async getTodayTasks(): Promise<WorkoutPlan[]> {
    let currentTime = new Date();
    let dayOfWeek = currentTime.getDay();
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.greaterThanOrEqualTo('StartDate', currentTime).and().lessThanOrEqualTo('EndDate',currentTime);
    const planArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
    let result: WorkoutPlan[]=[];
    //对每一个对象获取星期这个属性，进行判断
    for(let plan of planArray){
      if(this.parseAndCheck(plan.DayOfWeek,dayOfWeek)){
        result.push(plan);
      }
    }
    return result;
  }


}

import {ExercisePlanService} from '../service/ExercisePlanService'
import {RunningPlan} from'../bean/RunningPlan'
import { cloudDatabase } from '@kit.CloudFoundationKit';
import {runningPlan} from '../model/runningPlan'
import { UserPlan } from '../bean/UserPlan';
import { exercisePlan } from '../model/exercisePlan';

export class RunningPlanService extends ExercisePlanService{

  private static instance: RunningPlanService | null = null;

  private constructor() {
    super();
  }

  public static getInstance(): RunningPlanService{
    if (!RunningPlanService.instance) {
      RunningPlanService.instance = new  RunningPlanService();
    }
    return  RunningPlanService.instance;
  }

  public async getTodayTasks(): Promise<RunningPlan[]>{
    let currentTime = new Date();
    let dayOfWeek = currentTime.getDay();
    let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
    condition.greaterThanOrEqualTo('StartDate', currentTime).and().lessThanOrEqualTo('EndDate',currentTime);
    const planArray: RunningPlan[]= await this.agcDataBase.query(condition);
    let result: RunningPlan[]=[];
    //对每一个对象获取星期这个属性，进行判断
    for(let plan of planArray){
      if(this.parseAndCheck(plan.DayOfWeek,dayOfWeek)){
        result.push(plan);
      }
    }
    return result;
  }

  private ToBean(plan: runningPlan){
    let planContent =new RunningPlan();
    planContent.PlanID = plan.PlanID;
    planContent.PlanName =plan.PlanName;
    planContent.CoverPicture =plan.CoverPicture;
    planContent.PlanState =plan.PlanState;
    planContent.EndDate =plan.EndDate;
    planContent.DayOfWeek =plan.DayOfWeek;
    planContent.StartDate =plan.StartDate;
    planContent.ExecutionProgress =plan.ExecutionProgress;
    planContent.GoalOfTotalTime= plan.GoalOfTotalTime;
    planContent.GoalOfTotalMiles =plan.GoalOfTotalMiles;
    planContent.GoalOfSpeed = plan.GoalOfSpeed;
    return planContent
  }

  public async uploadPlan(plan: runningPlan,userID:string): Promise<boolean> {
    //向UserPlan、RunningPlan表中插入记录
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

  public async updatePlan(plan: runningPlan, userID: string): Promise<boolean> {
    const planContent =this.ToBean(plan);
    try {
      const planContent =this.ToBean(plan);
      await this.agcDataBase?.upsert(planContent);
      return true;
    } catch (err) {
      return false;
    }
  }

}

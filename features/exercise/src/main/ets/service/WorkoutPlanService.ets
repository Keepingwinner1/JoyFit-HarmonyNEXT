import {ExercisePlanService} from '../service/ExercisePlanService'
import {WorkoutPlan} from'../bean/WorkoutPlan'
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { workoutPlan } from'../model/workoutPlan'
import { PlanAction } from '../bean/PlanAction';
import { action } from '../model/action';
import { PlanTask } from '../bean/PlanTask';
import { WorkoutRecord } from '../bean/WorkoutRecord';

export class WorkoutPlanService extends ExercisePlanService {

  private static instance: WorkoutPlanService | null = null;

  private constructor() {
    super();
  }

  public static getInstance(): WorkoutPlanService{
    if (!WorkoutPlanService.instance) {
      WorkoutPlanService.instance = new WorkoutPlanService();
    }
    return  WorkoutPlanService.instance;
  }

  private ToBean(plan:workoutPlan,id:string){
    let planContent =new WorkoutPlan();
    planContent.PlanID = plan.PlanID;
    planContent.UserID =id;
    planContent.PlanName =plan.PlanName;
    planContent.CoverPicture =plan.CoverPicture;
    planContent.PlanState =plan.PlanState;
    planContent.EndDate =plan.EndDate;
    planContent.DayOfWeek =plan.DayOfWeek;
    planContent.StartDate =plan.StartDate;
    planContent.RestTimeBetweenSets = plan.RestTimeBetweenSets;
    planContent.RestTimeBetweenExercises =plan.RestTimeBetweenExercises;
    return planContent;
  }

  private planActionToBean(plan:workoutPlan,_action:action){
    let planAction = new PlanAction();
    planAction.PlanID = plan.PlanID;
    planAction.ActionID = _action.basicInfo?.ActionID;
    planAction.Sets =_action.basicInfo?.Sets;
    planAction.SingleSetNum =_action.basicInfo?.SingleSetNum;
    return planAction;
  }

  public async uploadPlan(plan:workoutPlan,userID:string): Promise<boolean> {
      const planContent =this.ToBean(plan,userID);
      let targetDates =this.getExecutionDates(plan.StartDate,plan.EndDate,plan.DayOfWeek);
      let taskArr: PlanTask[] =[];
      for(let date of targetDates){
        if(plan.PlanID != undefined)
          taskArr.push(this.taskToBean(plan.PlanID,userID,date))
      }
      let planActionArr: PlanAction[] =[];
      if(plan.includedActions != undefined)
        for(let _action of plan.includedActions){
          planActionArr.push(this.planActionToBean(plan,_action));
      }
      try {
        //向PlanAction表插入记录
        await this.agcDataBase?.upsert(planActionArr)
        //向WorkoutPlan表中插入记录
        await this.agcDataBase?.upsert(planContent);
        //向PlanTask插入待办任务
        await this.agcDataBase?.upsert(planContent);
        return true;
      } catch (err) {
        return false;
      }
  }

  public async updatePlan(plan: workoutPlan, userID: string): Promise<boolean> {
    const planContent =this.ToBean(plan,userID);
    try {
      await this.agcDataBase?.upsert(planContent);
      return true;
    } catch (err) {
      return false;
    }
  }

  public async getTodayTasks(userID:string): Promise<WorkoutPlan[]> {
    let currentTime = new Date();
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('UserID',userID).and().equalTo('ExecutedDate',currentTime).and().equalTo('TaskType','workout'); //这个判断条件可能要改
    const TaskArray: PlanTask[]= await this.agcDataBase.query(condition);
    let result: WorkoutPlan[]=[];
    for(let task of TaskArray) {
      let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
      condition.equalTo('PlanID',task.PlanID);
      let PlanArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
      let res = PlanArray.pop();
      if(res != undefined)
        result.push(res);
    }
    return result;
  }

  public async getNotStartedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','NotStarted');
    const planArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getCompletedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','Completed');
    const planArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getInProgressPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','InProgress');
    const planArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getAbandonedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','Abandoned');
    const planArray: WorkoutPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async deleteNotStartedPlan(plan:WorkoutPlan){
    try{
      let deleteNum = await this.agcDataBase.delete(plan);
      console.info(`Succeeded in deleting plan , result: ${deleteNum}`);
      return true;
    }
    catch(err){
      console.info(`Failed in deleting a plan: ${JSON.stringify(err)} `);
      return false;
    }
  }

  public async abandonInProgressPlan(targetPlan:WorkoutPlan){
    try{
      targetPlan.PlanState = "Abandoned";
      await this.agcDataBase?.upsert(targetPlan);
      console.info(`Succeeded in abandoning a plan.`);
      return true;
    }
    catch(err){
      console.info(`Failed in deleting a plan: ${JSON.stringify(err)} `);
      return false;
    }
  };

  public async uploadFeelings(record: WorkoutRecord) {
    try{
      await this.agcDataBase?.upsert(record);
      console.info(`Succeeded in uploading a record.`);
      return true;
    }
    catch(err){
      console.info(`Failed in uploading a record: ${JSON.stringify(err)} `);
      return false;
    }
  }

  public async getFeelingsByPlan(userID: string, planID: string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutRecord);
    condition.equalTo('UserID',userID).and().equalTo('PlanID',planID);
    const planArray: WorkoutRecord[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getRecords(userID: string, planID: string) {
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('UserID',userID).and().equalTo('PlanID',planID).and().equalTo('TaskType','workout');
    const planArray: PlanTask[]= await this.agcDataBase.query(condition);
    return planArray;
  }

}

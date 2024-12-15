import {ExercisePlanService} from '../service/ExercisePlanService'
import {RunningPlan} from'../bean/RunningPlan'
import { cloudDatabase } from '@kit.CloudFoundationKit';
import {runningPlan} from '../model/runningPlan'
import { PlanTask } from '../bean/PlanTask';
import {UUIDGenerator} from 'utils'
import { RunningRecord } from '../bean/RunningRecord';

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

  public async getTodayTasks(userID:string): Promise<RunningPlan[]>{
    let currentTime = new Date();
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('UserID',userID).and().equalTo('ExecutedDate',currentTime).and().equalTo('TaskType','running').and().equalTo('State','Pending'); //这个判断条件可能要改
    const TaskArray: PlanTask[]= await this.agcDataBase.query(condition);
    let result: RunningPlan[]=[];
    for(let task of TaskArray) {
      let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
      condition.equalTo('PlanID',task.PlanID);
      let PlanArray: RunningPlan[]= await this.agcDataBase.query(condition);
      let res = PlanArray.pop();
      if(res != undefined)
        result.push(res);
    }
    return result;
  }

  private runningPlanToBean(plan: runningPlan,id:string){
    let planContent =new RunningPlan();
    planContent.PlanID = plan.PlanID;
    planContent.UserID = id;
    planContent.PlanName =plan.PlanName;
    planContent.CoverPicture =plan.CoverPicture;
    planContent.PlanState =plan.PlanState;
    planContent.EndDate =plan.EndDate;
    planContent.DayOfWeek =plan.DayOfWeek;
    planContent.StartDate =plan.StartDate;
    planContent.GoalOfTotalTime= plan.GoalOfTotalTime;
    planContent.GoalOfTotalMiles =plan.GoalOfTotalMiles;
    planContent.GoalOfSpeed = plan.GoalOfSpeed;
    return planContent;
  }

  public async uploadPlan(plan:runningPlan,userID:string): Promise<boolean> {
    const planContent =this.runningPlanToBean(plan,userID);
    let targetDates =this.getExecutionDates(plan.StartDate,plan.EndDate,plan.DayOfWeek);
    let taskArr: PlanTask[] =[];
    for(let date of targetDates){
      if(plan.PlanID != undefined)
        taskArr.push(this.taskToBean(plan.PlanID,userID,date))
    }
    try {
      //向RunningPlan表中插入记录
      await this.agcDataBase?.upsert(planContent);
      //插入待办任务
      await this.agcDataBase?.upsert(planContent);
      return true;
    } catch (err) {
      return false;
    }
  }

  public async updatePlan(plan: runningPlan, userID: string): Promise<boolean> {
    const planContent =this.runningPlanToBean(plan,userID);
    try {
      await this.agcDataBase?.upsert(planContent);
      return true;
    } catch (err) {
      return false;
    }
  }

  public async getNotStartedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','NotStarted');
    const planArray: RunningPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getCompletedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','Completed');
    const planArray: RunningPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getInProgressPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','InProgress');
    const planArray: RunningPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getAbandonedPlan(userID:string) {
    let condition = new cloudDatabase.DatabaseQuery(RunningPlan);
    condition.equalTo('UserID',userID).and().equalTo('PlanState','Abandoned');
    const planArray: RunningPlan[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async deleteNotStartedPlan(plan:RunningPlan){
    try{
      let deleteNum = await this.agcDataBase.delete(plan);
      console.info(`Succeeded in deleting plan , result: ${deleteNum}`);
      return true;
    }
    catch(err){
      console.info(`Failed in deleting a plan: JSON.stringify(err)) `);
      return false;
    }
  }

  public async abandonInProgressPlan(targetPlan:RunningPlan){
    try{
      targetPlan.PlanState = "Abandoned";
      await this.agcDataBase?.upsert(targetPlan);
      console.info(`Succeeded in abandoning a plan.`);
      return true;
    }
    catch(err){
      console.info(`Failed in abandoning a plan: ${JSON.stringify(err)} `);
      return false;
    }
  }

  public async uploadFeelings(record: RunningRecord) {
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
    let condition = new cloudDatabase.DatabaseQuery(RunningRecord);
    condition.equalTo('UserID',userID).and().equalTo('PlanID',planID);
    const planArray: RunningRecord[]= await this.agcDataBase.query(condition);
    return planArray;
  }

  public async getRecords(userID: string, planID: string) {
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('UserID',userID).and().equalTo('PlanID',planID).and().equalTo('TaskType','running');
    const planArray: PlanTask[]= await this.agcDataBase.query(condition);
    return planArray;
  }

}

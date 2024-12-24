import {ExercisePlanService} from '../service/ExercisePlanService'
import {WorkoutPlan} from'../bean/WorkoutPlan'
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { workoutPlan } from'../model/workoutPlan'
import { PlanAction } from '../bean/PlanAction';
import { action, actionInfo } from '../model/action';
import { PlanTask } from '../bean/PlanTask';
import { WorkoutRecord } from '../bean/WorkoutRecord';
import { workoutPlanBuilder } from '../model/workoutPlanBuilder';
import { hilog } from '@kit.PerformanceAnalysisKit';

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

  public createPlanBuilder(): workoutPlanBuilder {
    return new workoutPlanBuilder();
  }

  private ToBean(plan:workoutPlan){
    let planContent =new WorkoutPlan();
    planContent.PlanID = plan.PlanID;
    planContent.UserID =plan.UserID;
    planContent.PlanName =plan.PlanName;
    planContent.CoverPicture =plan.CoverPicture;
    planContent.PlanState =plan.PlanState;
    planContent.EndDate =plan.EndDate;
    planContent.DayOfWeek =plan.DayOfWeek;
    planContent.StartDate =plan.StartDate;
    planContent.RestTimeBetweenSets = plan.RestTimeBetweenSets;
    planContent.RestTimeBetweenExercises =plan.RestTimeBetweenExercises;
    planContent.TotalTime =plan.TotalTime;
    planContent.Tag = plan.Tag;
    planContent.Description =plan.Description;
    return planContent;
  }

  private planActionToBean(plan:workoutPlan,_action:actionInfo){
    let planAction = new PlanAction();
    planAction.PlanID = plan.PlanID;
    planAction.ActionID = _action.ActionID;
    planAction.Sets =_action.Sets;
    planAction.SingleSetNum =_action.SingleSetNum;
    return planAction;
  }

  public async uploadPlan(plan:workoutPlan): Promise<boolean> {
      const planContent =this.ToBean(plan);
      let targetDates =this.getExecutionDates(plan.StartDate,plan.EndDate,plan.DayOfWeek);
      let taskArr: PlanTask[] =[];
      for(let date of targetDates){
        if(plan.PlanID != undefined && plan.UserID!=undefined)
          taskArr.push(this.taskToBean(plan.PlanID,plan.UserID,date))
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
        await this.agcDataBase?.upsert(taskArr);
        return true;
      } catch (err) {
        return false;
      }
  }

  private async deleteTask(planID: string){
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('PlanID',planID);
    const Array: PlanTask[]= await this.agcDataBase.query(condition);
    let deleteNum = this.agcDataBase.delete(Array);
  }

  private async deletePlanAction(planID:string){
    let condition2 = new cloudDatabase.DatabaseQuery(PlanAction);
    condition2.equalTo('PlanID',planID);
    const Array2: PlanAction[]= await this.agcDataBase.query(condition2);
    let deleteNum2 = this.agcDataBase.delete(Array2);
  }


  public async deletePlan(planID: string) {
    let condition = new cloudDatabase.DatabaseQuery(WorkoutPlan);
    condition.equalTo('PlanID',planID);
    let res = await this.agcDataBase.query(condition);
    let num= await this.agcDataBase.delete(res);
    //hilog.info(1,'删除数量',num.toString());
    this.deleteTask(planID);
    this.deletePlanAction(planID);
  }

  public async updatePlan(plan: workoutPlan) {
    //首先删除所有之前的计划记录（先查后删）
    try{
      if(plan.PlanID != undefined)
        await this.deletePlan(plan.PlanID);
      this.uploadPlan(plan);
      //再上传一个新的计划
      return true;
    } catch (err) {
      return false;
    }
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

  public async getTodayTasks(userID:string): Promise<WorkoutPlan[]> {
    let condition = new cloudDatabase.DatabaseQuery(PlanTask);
    condition.equalTo('UserID',userID).and(). equalTo('TaskType','workout'); //这个判断条件可能要改
    const Array: PlanTask[]= await this.agcDataBase.query(condition);
    //去除不属于今天的
    const TaskArray: PlanTask[]=[];
    for(let task of Array){
      if(task.ExecutedDate!=undefined)
        if(this.isToday(task.ExecutedDate))
          TaskArray.push(task);
    }
    //hilog.info(1,'今日任务',JSON.stringify(TaskArray));
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

  // public async deleteNotStartedPlan(plan:WorkoutPlan){
  //   try{
  //     let deleteNum = await this.agcDataBase.delete(plan);
  //     console.info(`Succeeded in deleting plan , result: ${deleteNum}`);
  //     return true;
  //   }
  //   catch(err){
  //     console.info(`Failed in deleting a plan: ${JSON.stringify(err)} `);
  //     return false;
  //   }
  // }

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

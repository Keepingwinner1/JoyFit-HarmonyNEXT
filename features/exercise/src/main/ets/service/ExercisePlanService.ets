import { cloudDatabase } from '@kit.CloudFoundationKit';
import {Action} from '../bean/Action'
import {RunningPlan} from'../bean/RunningPlan'
import {WorkoutPlan} from'../bean/WorkoutPlan'
import {PlanAction} from '../bean/PlanAction'
import {action} from '../model/action'
import { exercisePlan } from '../model/exercisePlan';
import { runningPlanBuilder } from '../model/runningPlanBuilder';
import { workoutPlanBuilder } from '../model/workoutPlanBuilder';
import { PlanTask } from '../bean/PlanTask';
import { UUIDGenerator } from 'utils';
import { RunningRecord } from '../bean/RunningRecord';
import { WorkoutRecord } from '../bean/WorkoutRecord';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON } from '@kit.ArkTS';

export abstract class ExercisePlanService {

  //可以从用户首选项中读取UserID信息,这样就不需要每次调用服务都传参了
  protected agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');

  public abstract uploadPlan(plan:exercisePlan,userID:string);
  public abstract getTodayTasks(userID:string);
  public abstract updatePlan(plan:exercisePlan,userID:string);
  public abstract getCompletedPlan(userID:string);
  public abstract getNotStartedPlan(userID:string);
  public abstract getInProgressPlan(userID:string);
  public abstract getAbandonedPlan(userID:string);
  //public abstract deleteNotStartedPlan(plan:RunningPlan|WorkoutPlan);
  public abstract abandonInProgressPlan(plan:RunningPlan|WorkoutPlan);
  public abstract uploadFeelings(record:RunningRecord|WorkoutRecord);
  public abstract getFeelingsByPlan(userID:string,planID:string);
  public abstract getRecords(userID:string,planID:string);
  public abstract createPlanBuilder():runningPlanBuilder|workoutPlanBuilder;
  public abstract deletePlan(planID:string);
  //{
    // switch (type){
    //   case 'running':
    //     return new runningPlanBuilder();
    //   case 'workout':
    //     return new workoutPlanBuilder();
    //   default:
    //     return null;
    // }
 // }

  public async getActionsByPlanID(planID: string){
    let condition = new cloudDatabase.DatabaseQuery(PlanAction);
    condition.equalTo('PlanID', planID);
    const actions : PlanAction[] = await this.agcDataBase.query(condition);
    //再拼接Action表的信息
    let result: action[] =[];
    for(let planAction of actions){
      let condition = new cloudDatabase.DatabaseQuery(Action);
      condition.equalTo('ActionID', planAction.ActionID);
      const goalAction : Action[] = await this.agcDataBase.query(condition);
      let actionRes =goalAction.pop();
      if(actionRes!= undefined){
        let res = action.createFromAction(actionRes,planAction);
        if(res != null)
          result.push(res);
      }
    }
    return result;
  }



  public async finishTask(taskID:string): Promise<boolean> {
    try{
      let condition = new cloudDatabase.DatabaseQuery(PlanTask);
      condition.equalTo('TaskID', taskID);
      const task : PlanTask[] = await this.agcDataBase.query(condition);
      let res = task.pop();
      if(res!=undefined)
        res.State = "Completed";
      await this.agcDataBase?.upsert(res);
      console.info(`Succeeded in completing a task.`);
      return true;
    }
    catch(err){
      console.info(`Failed in completing a plan: ${JSON.stringify(err)} `);
      return false;
    }
  }

  public async abandonTask(taskID:string): Promise<boolean> {
    try{
      let condition = new cloudDatabase.DatabaseQuery(PlanTask);
      condition.equalTo('TaskID', taskID);
      const task : PlanTask[] = await this.agcDataBase.query(condition);
      let res = task.pop();
      hilog.info(0,'测试',JSON.stringify(res));
      if(res!=undefined)
        res.State = "Abandoned";
      await this.agcDataBase?.upsert(res);
      console.info(`Succeeded in abandoning a task.`);
      return true;
    }
    catch(err){
      console.info(`Failed in abandoning a plan: ${JSON.stringify(err)} `);
      return false;
    }
  }

  protected getExecutionDates(startDate?: Date, endDate?: Date, daysOfWeekStr?: string): Date[] {
    const executionDates: Date[] = [];
    if(startDate!= undefined && endDate!=undefined && daysOfWeekStr!=undefined){
      const daysOfWeek = daysOfWeekStr.split('#').map(day => parseInt(day, 10));
      // 确保 daysOfWeek 是升序的，便于后续处理
      daysOfWeek.sort((a, b) => a - b);
      // 计算开始日期是星期几
      let currentDate = new Date(startDate);
      //const currentDayOfWeek = currentDate.getDay(); // Sunday - 0, Monday - 1, ..., Saturday - 6
      // 从开始日期开始，遍历到结束日期
      while (currentDate <= endDate) {
        const currentDay = currentDate.getDay(); // 当前日期的星期几
        // 如果当前星期几在用户指定的 daysOfWeek 中，就把当前日期添加到执行日期列表
        if (daysOfWeek.includes(currentDay)) {
          executionDates.push(new Date(currentDate));
        }
        // 增加一天，继续检查下一个日期
        currentDate.setDate(currentDate.getDate() + 1);
      }
    }
    return executionDates;
  }

  protected taskToBean(planID:string,userID:string,date:Date){
    let task = new PlanTask();
    task.TaskID = UUIDGenerator.getID();
    task.UserID =userID;
    task.PlanID =planID;
    task.ExecutedDate =date;
    task.State = 'Pending';
    task.TaskType ='workout';
    return task;
  }

}

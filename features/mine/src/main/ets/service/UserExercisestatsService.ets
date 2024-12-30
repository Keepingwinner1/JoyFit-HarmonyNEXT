import { ExerciseStates } from '../bean/ExerciseStates';
import { userExerciseStates } from '../model/userExerciseStates';
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {DateConverToNum}from "utils"
import { hilog } from '@kit.PerformanceAnalysisKit';

export class UserExerciseStatsService {
  private static instance: UserExerciseStatsService | null = null;
  private agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');


  private constructor() {}

  static getInstance(): UserExerciseStatsService {
    if (!UserExerciseStatsService.instance) {
      UserExerciseStatsService.instance = new UserExerciseStatsService();
    }
    return UserExerciseStatsService.instance;
  }

  //转化为数据库表的格式，类内调用
  private ToBean(ExerciseStats:userExerciseStates,uid:string){
    let recordExerciseStates= new ExerciseStates();
    recordExerciseStates.UserID=uid;
    //recordExerciseStates.TimeStamp=ExerciseStats.timeStamp.valueOf();
    recordExerciseStates.TimeStamp=DateConverToNum.convertDateToInteger(ExerciseStats.timeStamp);
    recordExerciseStates.TotalSteps=ExerciseStats.totalSteps;
    recordExerciseStates.TotalExerciseTime=ExerciseStats.totalExerciseTime;
    //卡路里可能需要修改
    recordExerciseStates.TotalCaloriesBurned=ExerciseStats.totalCalorisesBurned;

    return recordExerciseStates;

  }

  //更新用户的当日运动情况
  async updateUserExerciseStates(ExerciseStats: userExerciseStates, uid: string): Promise<boolean> {
    let record = this.ToBean(ExerciseStats, uid);  // 假设 ToBean 是用于将 ExerciseStats 转换为数据库记录的函数

    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'my-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'upsert',
            records: record
          }
        }, (err: BusinessError, result: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject({ message: err.message });  // Reject with error message, if needed
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(result.result)}`);
            resolve(result);
          }
        });
      });
      // 根据云函数返回的结果判断是否成功
      if (data.result) {
        return true;  // 成功的情况
      }

      // 默认返回 false，如果返回的结果不符合预期
      console.warn('Cloud function returned unexpected result:', data);
      return false;
    } catch (error) {
      // 捕获异常，记录错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }
  }





  //按照日期查看用户运动情况
  async getUserExerciseStates(uid:string,dateinteger:number):Promise<ExerciseStates>{
    try {
      let condition = new cloudDatabase.DatabaseQuery(ExerciseStates);
      condition.equalTo('UserID', uid).equalTo("TimeStamp",dateinteger);

      let exercisestates = await this.agcDataBase.query(condition);
      if(exercisestates.length==0){
        console.log('该用户不存在该日期下的记录');
      }
      return exercisestates[0];

    } catch (err) {
      console.error(`Failed to query exercisestates. Code: ${err.code}, Message: ${err.message}`);
      throw new Error(`Failed to query exercisestates for user with ID and Date: ${uid}_${dateinteger}`);
    }


  }



}

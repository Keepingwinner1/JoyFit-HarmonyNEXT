import { ExerciseStates } from '../bean/ExerciseStates';
import { userExerciseStates } from '../model/userExerciseStates';
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class UserExerciseStatsService {
  private static instance: UserExerciseStatsService | null = null;


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
    recordExerciseStates.TimeStamp=ExerciseStats.timeStamp.getTime();
    recordExerciseStates.TotalSteps=ExerciseStats.totalSteps;
    recordExerciseStates.TotalExerciseTime=ExerciseStats.totalCalorisesBurned;
    //卡路里可能需要修改
    recordExerciseStates.TotalCalories=ExerciseStats.totalCalorisesBurned;

    return recordExerciseStates;

  }

  //更新用户的当日运动情况
  async updateUserExerciseStates(ExerciseStats:userExerciseStates,uid:string):Promise<boolean>{
    let issuccess=true;
    let record = this.ToBean(ExerciseStats,uid);
    cloudFunction.call({
      name: 'my-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'upsert',
        records: [record]
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        issuccess=false;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
    })
    return issuccess;
  }



}

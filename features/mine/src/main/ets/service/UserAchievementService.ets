import { Achievement_User } from '../bean/Achievement_User';
import { Achievement } from '../bean/Achievement';
import { achievement } from '../model/achievement';
import { cloudDatabase } from '@kit.CloudFoundationKit';


export class UserAchievementService {
  private static instance: UserAchievementService | null = null;
  private agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');

  private constructor() {}

  static getInstance(): UserAchievementService {
    if (!UserAchievementService.instance) {
      UserAchievementService.instance = new UserAchievementService();
    }
    return UserAchievementService.instance;
  }

  private AchievementtoBean(newAchievement:achievement){
    let ach = new Achievement();
    ach.AchievementID=newAchievement.getAchievementID();
    ach.MedalName=newAchievement.getMedalName();
    ach.MedalImage=newAchievement.getMedalImage();
    ach.Description=newAchievement.getDescription();

    return ach;

  }

  private UserAchievementtoBean(newAchievement:achievement,uid:string){
    let userach = new Achievement_User();
    userach.AchievementID=newAchievement.getAchievementID();
    userach.UserID=uid;
    userach.AchieveTime=new Date();
    return userach;

  }

  // 通过 achievementID 查找荣誉及其相关信息
  async findAchievementByID(achievementID: string):Promise<Achievement> {
    try {
      // 创建查询条件，查找与 AchievementID 匹配的荣誉
      let condition = new cloudDatabase.DatabaseQuery(Achievement);
      condition.equalTo('AchievementID', achievementID);  // 根据 AchievementID 查询

      // 执行查询
      let result = await this.agcDataBase.query(condition);

      // 检查返回的结果
      if (result.length === 0) {
        console.info(`No achievement found with ID: ${achievementID}`);
      } else {
        // 如果找到相关荣誉，返回第一条记录
        console.info(`Found achievement: ${JSON.stringify(result[0])}`);
      }
      return result[0];
    } catch (err) {
      // 错误处理
      console.error(`Failed to find achievement. Code: ${err.code}, Message: ${err.message}`);
      throw new Error(`Failed to find achievement with ID: ${achievementID}`);
    }
  }

  // 通过用户ID查找该用户的所有荣誉的相关信息
  async getAchievementmedal(uid: string):Promise<Achievement[]> {
    try {
      let condition = new cloudDatabase.DatabaseQuery(Achievement_User);
      condition.equalTo('UserID', uid);

      let achievementUserArray = await this.agcDataBase.query(condition);

      if (achievementUserArray.length === 0) {
        console.info(`No achievements found for user with ID: ${uid}`);
        return [];  // 返回空数组
      } else {
        console.info(`Succeeded in querying achievements, result: ${JSON.stringify(achievementUserArray)}`);
      }

      let achievementIDs = achievementUserArray.map((record) => record.AchievementID);

      // 使用 Promise.all() 来并行查询荣誉的详细信息
      let achievementDetails: Achievement[] = []; // 显式声明类型为 Achievement[]
      let achievementResults = await Promise.all(
        achievementIDs.map((id): Promise<Achievement | null> => this.findAchievementByID(id as string))
      );

      // 过滤掉 null 或 undefined 的荣誉（如果有）
      achievementDetails = achievementResults.filter(item => item != null) as Achievement[];

      // 返回包含荣誉详细信息的数组
      return achievementDetails;
    } catch (err) {
      console.error(`Failed to query achievements. Code: ${err.code}, Message: ${err.message}`);
      throw new Error(`Failed to query achievements for user with ID: ${uid}`);
    }
  }

  //用户获得荣誉
  async addAchievement(Achievement:achievement,uid:string){


    let newUserAchievement=this.UserAchievementtoBean(Achievement,uid);

    try {

      let num = await this.agcDataBase.upsert([newUserAchievement]);


      // 根据返回结果判断成功或失败
      if ( num > 0) {
        console.info(`Successfully updated/inserted ${num} records.`);
        return true;
      } else {
        console.warn('No records were updated or inserted.');
        return false;
      }
    } catch (err) {
      // 错误处理
      console.error(`Failed to upsert, error: `, err);
      return false;
    }

  }

  //分享荣誉
  async shareAchievement(){


  }



}

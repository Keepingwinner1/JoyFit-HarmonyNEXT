import {athleticAbility} from "../model/athleticAbility"
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { AthleticAbility } from '../bean/AthleticAbility';

export class AthleticAbilityService{
  private static instance: AthleticAbilityService|null = null;
  private agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');

  private constructor() {}

  static getInstance(): AthleticAbilityService {
    if (!AthleticAbilityService.instance) {
      AthleticAbilityService.instance = new AthleticAbilityService();
    }
    return AthleticAbilityService.instance;
  }

  // 用户更新运动能力信息
  async updateInfo(newAthleticAbilityInfo: athleticAbility, uid: string) {
    if(!uid||!newAthleticAbilityInfo){
      console.error('Invalid parameters: BodyFat or uid is missing');
      return false;
    }
    try {
      let UserAthletic=new AthleticAbility();
      UserAthletic.UserID=uid;
      UserAthletic.RunningDistance=newAthleticAbilityInfo.runningDistance;
      UserAthletic.PushUpNums=newAthleticAbilityInfo.pushUpNums;
      UserAthletic.SquatNums=newAthleticAbilityInfo.squatNums;
      UserAthletic.CrunchNums=newAthleticAbilityInfo.crunchNums;
      let currentDate = new Date();
      UserAthletic.LastUpdated=currentDate;

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([UserAthletic]);

      // 根据返回结果判断成功或失败
      if (num > 0) {
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
}

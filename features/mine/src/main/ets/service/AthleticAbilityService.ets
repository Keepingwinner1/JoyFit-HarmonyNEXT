import {athleticAbility} from "../model/athleticAbility"
import { cloudDatabase } from '@kit.CloudFoundationKit';
import { AthleticAbility } from '../bean/AthleticAbility';
import {DateConverToNum} from "utils";

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
    let UserAthletic=new AthleticAbility();
    try {

      UserAthletic.UserID=uid;
      UserAthletic.RunningDistance=newAthleticAbilityInfo.runningDistance;
      UserAthletic.PushUpNums=newAthleticAbilityInfo.pushUpNums;
      UserAthletic.SquatNums=newAthleticAbilityInfo.squatNums;
      UserAthletic.CrunchNums=newAthleticAbilityInfo.crunchNums;
      let currentDate = new Date();
      UserAthletic.LastUpdated=DateConverToNum.convertDateToInteger(currentDate);

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert(UserAthletic);

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

  async getInfoByUserID(uid:string){
    if (!uid) {
      console.error('Invalid parameters: height or uid is missing');
      return false;
    }
    try {
      // 创建查询条件，查找指定 UserID 的 WeightData
      let condition = new cloudDatabase.DatabaseQuery(AthleticAbility);
      condition.equalTo('UserID', uid);  // 根据 UserID 查找

      condition.orderByDesc('LastUpdated');

      // 执行查询
      let InfoArray = await this.agcDataBase.query(condition);

      // 检查查询结果
      if (InfoArray == null) {
        console.info(`No height data found for user with ID: ${uid}`);
        return null;  // 如果没有找到，返回 null
      } else {

        console.info(`Found latest height data: ${JSON.stringify(InfoArray[0])}`);
        return InfoArray[0];
      }
    } catch (err) {
      console.error(`Failed to query weight data. Code: ${err.code}, Message: ${err.message}`);
      throw new Error(`Failed to get latest weight data for user with ID: ${uid}`);
    }
  }
}

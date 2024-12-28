import { cloudDatabase } from '@kit.CloudFoundationKit';
import { BodyHeight } from '../bean/BodyHeight';
import { WeightData } from '../bean/WeightData';
import {BodyFatData} from '../bean/BodyFatData';
import {DateConverToNum} from "utils";

export class BodyDataTrackerService {
  private static instance: BodyDataTrackerService | null = null;
  private agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');

  private constructor() {}

  static getInstance(): BodyDataTrackerService {
    if (!BodyDataTrackerService.instance) {
      BodyDataTrackerService.instance = new BodyDataTrackerService();
    }
    return BodyDataTrackerService.instance;
  }

  // 计算 BMI 的方法，内部调用
  private calculateBMI(height: number, weight: number): number {
    // 检查输入的身高和体重是否有效
    if (height <= 0 || weight <= 0) {
      throw new Error("Height and weight must be positive values.");
    }

    // 转换身高为米，假设 height 是以厘米为单位传入的
    const heightInMeters = height / 100;

    // 计算并返回 BMI
    return weight / (heightInMeters * heightInMeters);
  }

  //获取用户最新的WeigtData
  async getLatestWeightData(userID: string) {
      try {
         // 创建查询条件，查找指定 UserID 的 WeightData
        let condition = new cloudDatabase.DatabaseQuery(WeightData);
         condition.equalTo('UserID', userID);  // 根据 UserID 查找

         // 按 WeightRecordTime 降序排序，确保最新的记录排在前面
         condition.orderByDesc('WeightRecordTime');


         // 执行查询
         let weightDataArray = await this.agcDataBase.query(condition);

         // 检查查询结果
         if (weightDataArray.length === 0) {
           console.info(`No weight data found for user with ID: ${userID}`);
           return null;  // 如果没有找到，返回 null
         } else {
          // 返回最新的 WeightData（数组中的第一条记录）
           console.info(`Found latest weight data: ${JSON.stringify(weightDataArray[0])}`);
           return weightDataArray[0];  // 返回最新的记录
         }
       } catch (err) {
         console.error(`Failed to query weight data. Code: ${err.code}, Message: ${err.message}`);
         throw new Error(`Failed to get latest weight data for user with ID: ${userID}`);
       }
  }

  //获取用户身高BodyHeight
  async getUserHeight(uid:string){
    if (!uid) {
      console.error('Invalid parameters: height or uid is missing');
      return false;
    }
    try {
      // 创建查询条件，查找指定 UserID 的 WeightData
      let condition = new cloudDatabase.DatabaseQuery(BodyHeight);
      condition.equalTo('UserID', uid);  // 根据 UserID 查找

      // 执行查询
      let HeightData = await this.agcDataBase.query(condition);

      // 检查查询结果
      if (HeightData == null) {
        console.info(`No height data found for user with ID: ${uid}`);
        return null;  // 如果没有找到，返回 null
      } else {

        console.info(`Found latest height data: ${JSON.stringify(HeightData[0].Height)}`);
        return HeightData[0];
      }
    } catch (err) {
      console.error(`Failed to query weight data. Code: ${err.code}, Message: ${err.message}`);
      throw new Error(`Failed to get latest weight data for user with ID: ${uid}`);
    }
  }

  //用户修改身高，会引发BMI更新
  async modifyheight(uid:string,height:number){
    if (!height || !uid) {
      console.error('Invalid parameters: height or uid is missing');
      return false;
    }

    try {
      let userheight=new BodyHeight();
      userheight.UserID=uid;
      userheight.Height=height;
      let currentDate = new Date();
      userheight.LastUpdateTime=currentDate;

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([userheight]);

      // 获取最新体重数据
      let latestweightdata = await this.getLatestWeightData(uid);
      if (latestweightdata?.Weight != null) {
        let latestBMI = this.calculateBMI(height, latestweightdata.Weight);
        // 更新体重数据的 BMI
        await this.updateWeight(uid, latestweightdata.Weight, latestBMI);
      } else {
        console.warn('No weight data found to update BMI');
      }


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

  //更新WeightData，用于该层modifyheight()函数使用
  private async updateWeight(uid:string,weight:number,newBMI:number){
    if (!weight || !uid|| !newBMI) {
      console.error('Invalid parameters: weight or uid or newBMI is missing');
      return false;
    }
    try {
      let userweight=new WeightData();
      userweight.UserID=uid;
      userweight.Weight=weight;
      userweight.BMI=newBMI;
      let currentDate = new Date();
      userweight.WeightRecordTime=DateConverToNum.convertDateToInteger(currentDate);

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([userweight]);

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

  //用户增加历史体重，会引发BMI更新，作为外部调用接口
  async addWeight(uid:string,weight:number){
    if (!weight || !uid) {
      console.error('Invalid parameters: weight or uid is missing');
      return false;
    }
    try {
      let userweight=new WeightData();
      userweight.UserID=uid;
      userweight.Weight=weight;
      let currentDate = new Date();
      userweight.WeightRecordTime=DateConverToNum.convertDateToInteger(currentDate);
      // 获取该用户的身高数据
      let HeightData = await this.getUserHeight(uid);
      if(!HeightData){
        console.warn('Height data not found, BMI calculation skipped');
      }
      else {
        if (HeightData != null) {
          if ( HeightData.Height!=0&&HeightData.Height!=null) {
            // 计算BMI
            let newBMI = this.calculateBMI(HeightData.Height, userweight.Weight);
            userweight.BMI = newBMI;
          } else {
            console.warn('Height data is invalid or not found, BMI calculation skipped');
          }
        } else {
          console.warn('Height data not found, BMI calculation skipped');
        }
      }
      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([userweight]);


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

  //用户更新体脂数据
  async addBodyFatRate(uid:string,BodyFat:number){
    if(!uid||!BodyFat){
      console.error('Invalid parameters: BodyFat or uid is missing');
      return false;
    }
    try {
      let userBodyFat=new BodyFatData();
      userBodyFat.UserID=uid;
      userBodyFat.BodyFatRate=BodyFat;
      let currentDate = new Date();
      userBodyFat.BodyFatRecordTime=DateConverToNum.convertDateToInteger(currentDate);
      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([userBodyFat]);

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

  //用户获取历史体重数据
  async getWeightHistory(uid:string){
    if(!uid){
      console.error('Invalid parameters: BodyFat or uid is missing');
      return false;
    }
    try{
       let condition = new cloudDatabase.DatabaseQuery(WeightData);
       condition.equalTo('UserID', uid);

       let WeightHistoryArray = await this.agcDataBase.query(condition);
       console.info(`Succeeded in querying , result: ${JSON.stringify(WeightHistoryArray)}`);
       return WeightHistoryArray;
    } catch (err) {
      console.error(`Failed to query , Code: ${err.code}, message: ${err.message}`);
      return false;
    }
  }

  //用户获取历史体脂数据
  async getBodyFatRateHistory(uid:string){
    if(!uid){
      console.error('Invalid parameters: BodyFat or uid is missing');
      return false;
    }
    try{
      let condition = new cloudDatabase.DatabaseQuery(BodyFatData);
      condition.equalTo('UserID', uid);

      let BodyFatDataHistoryArray = await this.agcDataBase.query(condition);
      console.info(`Succeeded in querying , result: ${JSON.stringify(BodyFatDataHistoryArray)}`);
      return BodyFatDataHistoryArray;
    } catch (err) {
      console.error(`Failed to query , Code: ${err.code}, message: ${err.message}`);
      return false;
    }

  }



}

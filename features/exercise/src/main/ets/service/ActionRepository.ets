import {action} from '../model/action';
import {Action} from '../bean/Action';
import {UserAction} from '../bean/UserAction';
import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError,request } from '@kit.BasicServicesKit';
import{ActionFactory} from '../model/actionFactory'
interface GeneratedTypeLiteralInterface_1 {
  code: number;
  desc: string;
}

interface CFReturn {
  ret: GeneratedTypeLiteralInterface_1;
  result: Action[];
}

export class ActionRepository {
  private static instance: ActionRepository | null = null;

  private constructor() {}

  static getInstance(): ActionRepository {
    if (!ActionRepository.instance) {
      ActionRepository.instance = new ActionRepository();
    }
    return ActionRepository.instance;
  }


  private test(){

  }
  private ToBean(newAction: action){
    let action=new Action();
    action.ActionID=newAction.basicInfo?.ActionID;
    action.ActionName=newAction.basicInfo?.ActionName;
    action.ActonType=newAction.basicInfo?.ActonType;
    action.IntroductionVideo=newAction.IntroductionVideo;
    action.IntroductionVoice=newAction.IntroductionVoice;
    action.Description=newAction.Description;
    action.TimeOfOne=newAction.TimeOfOne;
    action.MainTrainingPart=newAction.MainTrainingPart;
    action.IsUserDefined=true;
    action.Carlories=newAction.Calories;

    return action;
  }

  private ToBeanUserAction(userID:string,actionID:string){
    let useraction=new UserAction();
    useraction.ActionID=actionID;
    useraction.UserID=userID;

    return useraction;
  }

  //getAllwarmUpActions,获取所有的热身动作,不返回非该用户创建的动作
  async getAllwarmUpActions(){
    //调用云函数，获取
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'queryActionofWarmUp',
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        return;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
      const cfReturn = data as CFReturn;
      return cfReturn.result;
    })

  }

  //getAllfitnessActions(): List<Action>获取所有的健身动作,不返回非该用户创建的动作
  async getAllfitnessActions(uid:String){
    //调用云函数，获取
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'queryActionofFitness',
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        return ;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
      const cfReturn = data as CFReturn;
      return cfReturn.result;
    })

  }

  //getAllRelaxActions(): List<Action>获取所有的拉伸动作,不返回非该用户创建的动作
  async getAllRelaxActions(uid:String){

    let TypeName="StretchRelax";
    //调用云函数，获取
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'queryActionofStretchRelax',
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        return;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
      const cfReturn = data as CFReturn;
      return cfReturn.result;
    })

  }

  //addNewAction(newAction: Action): boolean
  async addNewAction(newAction: action,uid:string):Promise<boolean>{

    let issuccess=true;
    //上传音频和视频

    //转化为数据库格式
    let waittoadd = this.ToBean(newAction);
    if (waittoadd.ActionID != null) {
      let useraction = this.ToBeanUserAction(uid, waittoadd.ActionID);

      cloudFunction.call({
        name: 'action-bycyb-cloud-function',
        version: '$latest',
        timeout: 10 * 1000,
        data: {
          operation: 'upsertAction',
          records: waittoadd
        }
      }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
        if (err) {
          console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
          issuccess=false;
        }
        console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

      })

      if(!issuccess){
        return false;
      }
      else {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'upsertUserAction',
            records: useraction
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            issuccess = false;

          }
          console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

        })
        return issuccess;
      }
    }
    else{
      return false;
    }

  }

  // deleteMyAction(actionID: Integer): boolean
  async deleteMyAction(oldAction: action,uid:string):Promise<boolean>{

    let issuccess=true;
    let actionID=oldAction.basicInfo?.ActionID;
    //调用工具函数删除媒体资源

    //调用云函数查找到该用户所有的action，参数为userID
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'deleteAction',
        records: {"ActionID":actionID}
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        issuccess=false;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

    })
    if(!issuccess){
      return false;
    }
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'deleteUserAction',
        records: {"ActionID":actionID,"UserID":uid}
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

  //getMyAction(uid:string):List<Action>,查找该用户创建的所有动作
  async getMyAction(uid: string) {
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'queryActionByUserID',
        records: { "UserID": uid }
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        return;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

      // data.result中假设是一个数组，包含用户的ActionID列表
      const userActions = data.result as Action[];
      const actionIDs = userActions.map(item => item.ActionID);

      // 在第一个调用的回调中发起第二个调用
      cloudFunction.call({
        name: 'action-bycyb-cloud-function',
        version: '$latest',
        timeout: 10 * 1000,
        data: {
          operation: 'queryActionByActionID',
          records: { "ActionIDs": actionIDs } // 假设第二个接口支持传入ActionID数组
        }
      }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
        if (err) {
          console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
          return;
        }
        console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

        // data.result里现在是对应ActionID的Action详细信息
        const actions = data.result;
        return actions;
      })
    });
  }

  //getAllAction()查找所有动作
  async getAllAction():Promise<Action[]>{
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'queryAllAction'
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
      const cfReturn = data as CFReturn;
      return cfReturn.result;
    });
    return [];

  }



}

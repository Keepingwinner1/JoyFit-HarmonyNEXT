import {action} from '../model/action';
import {Action} from '../bean/Action';
import {UserAction} from '../bean/UserAction';
import {PlanAction} from '../bean/PlanAction';
import { cloudFunction } from '@kit.CloudFoundationKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface RetofResult {
  code: number;
  desc: string;
}

interface ResultofActionSearch {
  ret: RetofResult;
  result: Action[];
}

interface ResultofUserActionSearch {
  ret: RetofResult;
  result: UserAction[];
}

interface ResultofPlanActionSearch {
  ret: RetofResult;
  result: PlanAction[];
}

interface ResultofUserSingleActionSearch {
  ret: RetofResult;
  result: Action;
}

export class ActionRepository {
  private static instance: ActionRepository | null = null;

  private constructor() {}

  static getInstance(): ActionRepository {9
    if (!ActionRepository.instance) {
      ActionRepository.instance = new ActionRepository();
    }
    return ActionRepository.instance;
  }



  private ToBean(newAction: action){
    let action=new Action();
    action.ActionID=newAction.basicInfo?.ActionID;
    action.ActionName=newAction.basicInfo?.ActionName;
    action.Note=newAction.Note;
    action.IntroductionVideo=newAction.IntroductionVideo;
    action.IntroductionVoice=newAction.IntroductionVoice;
    action.Description=newAction.Description;
    action.TimeOfOne=newAction.TimeOfOne;
    action.MainTrainingPart=newAction.MainTrainingPart;
    action.IsUserDefined=true;
    action.Calories=newAction.Calories;

    return action;
  }

  private ToBeanUserAction(userID:string,actionID:string){
    let useraction=new UserAction();
    useraction.ActionID=actionID;
    useraction.UserID=userID;

    return useraction;
  }

  //获取所有的胸部动作
  async getAllChestActions():Promise<Action[] | boolean>{
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofChest',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`+data.result.toString());
            console.info(data.result.toString());
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      console.info(cfReturn.result.toString());
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }
  }

  //获取所有的背部动作
  async getAllBackActions():Promise<Action[] | boolean>{
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofBack',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }

  }

  //获取所有的腿部动作
  async getAllLegActions():Promise<Action[] | boolean>{
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofLeg',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }



  }

  //获取所有的手臂动作
  async getAllArmsActions(): Promise<Action[] | boolean> {
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofArms',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }
  }


  //获取所有的腹部动作
  async getAllAbdomenActions():Promise<Action[] | boolean>{
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofAbdomen',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }

  }

  //获取所有的肩部动作
  async getAllShouldersActions(): Promise<Action[] |boolean> {
    try {
      // 直接返回 cloudFunction 的结果
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionofShoulders',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false if there's an error
          } else {
            resolve(data);  // Resolve with the cloud function result
          }
        });
      });

      // 处理查询结果并返回 Action 数组
      const cfReturn = data.result as ResultofActionSearch;

      // 如果查询结果中有 Action 数据
      if (cfReturn.result && Array.isArray(cfReturn.result)) {
        console.info(`Received Actions: ${JSON.stringify(cfReturn.result)}`);
        return cfReturn.result;  // 返回 Action 数组
      } else {
        console.error("No valid action results found.");
        return cfReturn.result;  // 返回 false 如果没有有效的数据
      }

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }
  }


  //addNewAction(newAction: Action): boolean
  async addNewAction(newAction: action, uid: string): Promise<boolean> {

    // 转化为数据库格式
    let waittoadd = this.ToBean(newAction);

    if (waittoadd.ActionID != null) {
      let useraction = this.ToBeanUserAction(uid, waittoadd.ActionID);

      // 使用Promise包装异步操作
      try {
        // 第一次异步调用
        const upsertActionResult = await new Promise<boolean>((resolve, reject) => {
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
              reject(false);  // 错误时reject
            } else {
              console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
              resolve(true);  // 成功时resolve
            }
          });
        });

        // 如果第一个调用失败，直接返回false
        if (!upsertActionResult) {
          return false;
        }

        // 第二次异步调用
        const upsertUserActionResult = await new Promise<boolean>((resolve, reject) => {
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
              reject(false);  // 错误时reject
            } else {
              console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
              resolve(true);  // 成功时resolve
            }
          });
        });

        // 如果第二个调用失败，直接返回false
        if (!upsertUserActionResult) {
          return false;
        }

        // 如果两个调用都成功，返回true
        return true;

      } catch (error) {
        // 捕获到任何错误时，返回false
        console.error("Error in addNewAction:", error);
        return false;
      }
    } else {
      return false;
    }
  }




  //deleteMyAction
  // deleteMyAction(actionID: Integer): boolean
  async deleteMyAction(oldAction: action,uid:string):Promise<boolean>{

    let issuccess=true;
    let relationActionwithPlan=false;
    let actionID=oldAction.basicInfo?.ActionID;

    //测试用例
    //{
    //   "operation": "relationActionWithPlan",
    //   "records": "12345"
    // }

    //判断是否有计划相关联
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'relationActionWithPlan',
        records: actionID
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        issuccess=false;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
      const resultofRelation=data.result as ResultofPlanActionSearch;
      if (resultofRelation.result.length==0) {
        // 如果没有返回结果，说明没有计划与目标 Action 关联
        relationActionwithPlan = true;
      } else {
        // 如果有结果，说明计划与目标 Action 关联
        relationActionwithPlan = false;
      }
    })

    if(relationActionwithPlan){
      console.info(`There is a relationship between Plan and Action,fail to delete`);
      return false;
    }

    if(!issuccess){
      return false;
    }


    //调用云函数删除目标动作
    cloudFunction.call({
      name: 'action-bycyb-cloud-function',
      version: '$latest',
      timeout: 10 * 1000,
      data: {
        operation: 'deleteAction',
        records: actionID
      }
    }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
      if (err) {
        console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
        issuccess=false;
      }
      console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);

    })

    //判断前一次操作是否成功
    if(!issuccess){
      return false;
    }


    //调用云函数删除UserAction表中的关系
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

    //判断前一次操作是否成功
    if(!issuccess){
      return false;
    }

    return issuccess;
  }


 //查找用户自建动作
  async getMyAction(uid: string): Promise<Action[] | boolean> {
    try {
      // 第一个异步调用：获取用户的 ActionID 列表
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryActionByUserID',
            records: uid
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // 调用失败时返回 false
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // 调用成功时返回 data
          }
        });
      });

      // 获取用户的 ActionID 列表并检查数据有效性
      const cfReturn = data.result as ResultofUserActionSearch;
      const userActions= cfReturn.result;
      if (!userActions || userActions.length == 0) {
        console.error('No actions found for the user.');
        return false;  // 如果没有找到用户的 Action，返回 false
      }


      const actionIDs = userActions.map(item => item.ActionID);

      // 使用 Promise.all 并行调用 queryActionByActionID 获取每个 Action
      const actions = await Promise.all(actionIDs.map(async (actionID) => {
        try {
          console.info("傻逼华为2");
          const result = await new Promise<Action | null>((resolve, reject) => {
            cloudFunction.call({
              name: 'action-bycyb-cloud-function',
              version: '$latest',
              timeout: 10 * 1000,
              data: {
                operation: 'queryActionByActionID',
                records: actionID
              }
            }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
              if (err) {
                console.error(`Failed to call the function for ActionID: ${actionID}, Code: ${err.code}, message: ${err.message}`);
                reject(null);  // 如果失败，返回 null
              } else {
                console.info(`Succeeded in calling the function for ActionID: ${actionID}, result: ${JSON.stringify(data.result)}`);
                const resultofActionSearch=data.result as ResultofUserSingleActionSearch;
                resolve(resultofActionSearch.result);  // 成功时返回 Action 对象
              }
            });
          });

          return result ;  // 返回获取到的单个 Action 或 null

        } catch (error) {
          console.error(`Error fetching action for ActionID: ${actionID}:`, error);
          return null;  // 如果某个 Action 查询失败，返回 null
        }
      }));

      // 过滤掉为 null 的结果
      const validActions = actions.filter(action => action !== null) as Action[];

      if (validActions.length === 0) {
        console.error('No valid actions found.');
        return false;  // 如果没有有效的 Action，返回 false
      }

      // 返回所有的 Action 数组
      return validActions;

    } catch (error) {
      console.error('Error occurred:', error);
      return false;  // 捕获错误时返回 false
    }
  }


  //getAllAction()查找所有动作
  async getAllAction():Promise<Action[] | boolean>{
    try {
      const data: cloudFunction.FunctionResult = await new Promise((resolve, reject) => {
        cloudFunction.call({
          name: 'action-bycyb-cloud-function',
          version: '$latest',
          timeout: 10 * 1000,
          data: {
            operation: 'queryAllAction',
          }
        }, (err: BusinessError, data: cloudFunction.FunctionResult) => {
          if (err) {
            console.error(`Failed to call the function, Code: ${err.code}, message: ${err.message}`);
            reject(false);  // Reject with false or any relevant error information
          } else {
            console.info(`Succeeded in calling the function, result: ${JSON.stringify(data.result)}`);
            resolve(data);  // Resolve with the data from the cloud function
          }
        });
      });

      // 处理查询结果并返回
      const cfReturn = data.result as ResultofActionSearch;
      return cfReturn.result;

    } catch (error) {
      // 捕获错误并返回 false
      console.error('Error occurred:', error);
      return false;
    }
  }

}

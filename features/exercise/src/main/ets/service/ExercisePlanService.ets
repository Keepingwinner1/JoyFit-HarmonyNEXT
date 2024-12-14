import { cloudDatabase } from '@kit.CloudFoundationKit';
import {Action} from '../bean/Action'
import {RunningPlan} from'../bean/RunningPlan'
import {WorkoutPlan} from'../bean/WorkoutPlan'
import {PlanAction} from '../bean/PlanAction'
import {action,actionInfo} from '../model/action'
import { exercisePlan } from '../model/exercisePlan';

export abstract class ExercisePlanService {

  //可以从用户首选项中读取UserID信息,这样就不需要每次调用服务都传参了
  protected agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');

  public abstract uploadPlan(plan:exercisePlan,userID:string);
  public abstract getTodayTasks();
  public abstract updatePlan(plan:exercisePlan,userID:string)
  //public abstract

  // 解析以#分隔的数字字符串，并判断某个数字是否在这个数组中
  protected parseAndCheck(input: string|undefined, numToCheck: number): boolean {
  // Step 1: 使用split将字符串按#分割，得到一个字符串数组
    if(typeof input == 'string'){
      let strArray = input.split('#');
      // Step 2: 使用map将字符串数组转换为数字数组
      let numArray = strArray.map(str => parseInt(str, 10));  // 或使用 +str 进行转换
      // Step 3: 使用includes判断数字是否在数组中
      return numArray.includes(numToCheck);
    }
    else{
      console.log("传入参数非string");
      return false;
    }
  }

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
      if(actionRes!= undefined)
        result.push(action.createFromAction(actionRes,planAction));
    }
    return result;
  }
}

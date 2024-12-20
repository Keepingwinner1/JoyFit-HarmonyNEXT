import {Action} from '../bean/Action'
import {PlanAction} from '../bean/PlanAction'
import { BasicPrefetcher } from '@kit.ArkUI';
import {action} from './action'

export abstract class exercisePlan {
  public PlanID: string |undefined;
  public PlanName: string | undefined;  // String类型
  public CoverPicture: string | undefined;  // String类型
  public PlanType: string | undefined;  // String类型  running workout
  public PlanState: string | undefined;  // String类型  NotStarted Abandoned InProgress Completed
  public DayOfWeek: string | undefined;  // String类型,0到6分别代表周日到周六，以#分割 0#1#2
  public StartDate: Date | undefined;  // Date类型
  public EndDate: Date | undefined;  // Date类型
  public includedActions : action[] =[];
}



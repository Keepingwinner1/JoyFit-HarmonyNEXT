import {Action} from '../bean/Action'
import {PlanAction} from '../bean/PlanAction'
import { BasicPrefetcher } from '@kit.ArkUI';
import {action} from './action'

export abstract class exercisePlan {
  public PlanID: string |undefined;
  public PlanName: string | undefined;  // String类型
  public CoverPicture: string | undefined;  // String类型
  public PlanType: string | undefined;  // String类型
  public PlanState: string | undefined;  // String类型
  public DayOfWeek: string | undefined;  // String类型,0到6分别代表周日到周六，以#分割
  public StartDate: Date | undefined;  // Date类型
  public EndDate: Date | undefined;  // Date类型
  public ExecutionProgress: number | undefined; // Double类型
  public includedActions : action[] | undefined;
}



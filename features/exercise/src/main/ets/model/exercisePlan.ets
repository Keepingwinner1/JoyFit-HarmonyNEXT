import {Action} from '../bean/Action'
import {PlanAction} from '../bean/PlanAction'
import { BasicPrefetcher } from '@kit.ArkUI';
import {action, actionInfo} from './action'
import { PlanBuilder } from './planBuilder';

export abstract class exercisePlan {
  public PlanID: string |undefined;
  public PlanName: string | undefined;  // String类型
  public UserID: string | undefined;
  public CoverPicture: string | undefined;  // String类型
  public PlanState: string | undefined;  // String类型  NotStarted Abandoned InProgress Completed
  public DayOfWeek: string = '';  // String类型,0到6分别代表周日到周六，以#分割 0#1#2
  public StartDate: Date | undefined;  // Date类型
  public EndDate: Date | undefined;  // Date类型
  public Tag: string ='';
  public Description : string ='';
  public includedActions : actionInfo[] =[];

  constructor(builder: PlanBuilder){
    this.PlanID =builder.PlanID;
    this.PlanName =builder.PlanName;
    this.UserID =builder.UserID;
    this.CoverPicture =builder.CoverPicture;
    this.PlanState =builder.PlanState;
    this.DayOfWeek =builder.DayOfWeek;
    this.StartDate =builder.StartDate;
    this.EndDate =builder.EndDate;
    this.Tag = builder.Tag;
    this.Description=builder.Description;
    for(let action of builder.SelectedActions)
      this.includedActions.push(action);
  }
}



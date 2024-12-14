import{exercisePlan} from './exercisePlan'
import{action} from'./action'
import {UUIDGenerator} from 'utils'

// PlanBuilder 基类
export abstract class PlanBuilder {
  public PlanID: string = UUIDGenerator.getID();   //创建对象时自动设置 PlanID
  public PlanName: string | undefined;
  public CoverPicture: string | undefined;
  public PlanState: string | undefined;
  public DayOfWeek: string | undefined;
  public StartDate: Date | undefined;
  public EndDate: Date | undefined;
  public ExecutionProgress: number | undefined;
  public SelectedActions :action[] = [];

  setPlanID(PlanID:string):PlanBuilder{
    this.PlanID =PlanID;
    return this;
  }

  // 设置 PlanName
  setPlanName(PlanName: string): PlanBuilder {
    this.PlanName = PlanName;
    return this;
  }

  // 设置 CoverPicture
  setCoverPicture(CoverPicture: string): PlanBuilder {
    //上传至云存储后再赋值URL，还是要先判断是否已经为URL

    this.CoverPicture = CoverPicture;
    return this;
  }

  // 设置 PlanState
  setPlanState(PlanState: string): PlanBuilder {
    this.PlanState = PlanState;
    return this;
  }

  // 设置 EndDate
  setEndDate(EndDate: Date): PlanBuilder {
    this.EndDate = EndDate;
    return this;
  }

  // 设置 DayOfWeek
  setDayOfWeek(DayOfWeek: string): PlanBuilder {
    this.DayOfWeek = DayOfWeek;
    return this;
  }

  // 设置 StartDate
  setStartDate(StartDate: Date): PlanBuilder {
    this.StartDate = StartDate;
    return this;
  }

  // 设置 ExecutionProgress
  setExecutionProgress(ExecutionProgress: number): PlanBuilder {
    this.ExecutionProgress = ExecutionProgress;
    return this;
  }

  //添加动作
  addAction(selectedAction: action) : PlanBuilder{
    this.SelectedActions.push(selectedAction);
    return this;
  }

  // 抽象的 build 方法，由子类实现
  abstract build(): exercisePlan;
}

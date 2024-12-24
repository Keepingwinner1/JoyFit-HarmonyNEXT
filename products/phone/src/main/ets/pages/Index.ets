import {UUIDGenerator} from "utils"
import {ExercisePlanService,RunningPlanService,WorkoutPlanService,ActionRepository} from "exercise"
import {actionInfo,exercisePlan,runningPlan,workoutPlan,PlanBuilder,runningPlanBuilder,workoutPlanBuilder} from "exercise"
import { BusinessError } from "@kit.BasicServicesKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import {WorkoutPlan} from "exercise"
import {PlanTask} from "exercise"

/*
 待测接口
  public async getActionsByPlanID(planID: string)
  public async finishTask(task:PlanTask): Promise<boolean> ok
  public async abandonTask(task:PlanTask): Promise<boolean> ok
  public abstract uploadPlan(plan:exercisePlan);  ok
  public async deletePlan(planID: string);
  public abstract getTodayTasks(userID:string);  ok
  public abstract updatePlan(plan:exercisePlan,userID:string);
  public abstract getCompletedPlan(userID:string);
  public abstract getNotStartedPlan(userID:string);
  public abstract getInProgressPlan(userID:string);
  public abstract getAbandonedPlan(userID:string);
  public abstract deleteNotStartedPlan(plan:RunningPlan|WorkoutPlan);
  public abstract abandonInProgressPlan(plan:RunningPlan|WorkoutPlan);
  public abstract uploadFeelings(record:RunningRecord|WorkoutRecord);
  public abstract getFeelingsByPlan(userID:string,planID:string);
  public abstract getRecords(userID:string,planID:string);
  public abstract createPlanBuilder():runningPlanBuilder|workoutPlanBuilder;
 * */


@Entry
@Component
struct Index {
  @State todayTasks: WorkoutPlan[] = [];
  @State todayTasksString: string ='';
  ex: WorkoutPlanService = WorkoutPlanService.getInstance();

  build() {
    Column() {
      Button('上传计划')
        .onClick(() =>{
          this.uploadPlan();
        })

      Button('更新计划')
        .onClick(()=>{
          this.updatePlan();
        })

      Button('删除计划')
        .onClick(()=>{
          this.ex.deletePlan('16,33,86');
        })

      Button('获取今日任务')  //会返回所有今天的任务，未做已完成、已放弃、待完成区分，可以利用State字段实现
        .onClick(()=>{
         this.ex.getTodayTasks('1').then((result:WorkoutPlan[])=>{
           this.todayTasks = result; //可以直接使用这个变量进行后续展示处理
           this.todayTasksString  = JSON.stringify(result);
          }
         )
        })
      Text(this.todayTasksString)

      Button('完成任务')
        .onClick(()=>{
          this.ex.finishTask('121,152,16')
        })

      Button('放弃任务')
        .onClick(()=>{
          this.ex.abandonTask('145,130,93')
        })

      //this.text = UUIDGenerator.getID();
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }

  updatePlan(){
    let test_workoutBuilder= this.ex.createPlanBuilder();
    //初始化动作
    let actioninfo: actionInfo = new actionInfo();
    actioninfo.ActionName ='动作3'; //所选动作填入
    actioninfo.ActionID = '333'; //所选动作填入
    actioninfo.Sets = 3;
    actioninfo.SingleSetNum =5 ;

    let actions: actionInfo[] = [];//创建空数组
    actions.push(actioninfo);//放入确定好的动作
    let actioninfo2: actionInfo = new actionInfo(); //代表加入另一个新动作，必须要new一个新对象，不可以复用之前的对象
    actioninfo2.ActionName ='动作4'; //所选动作填入
    actioninfo2.ActionID = '444'; //所选动作填入
    actioninfo2.Sets = 4;
    actioninfo2.SingleSetNum =5 ;
    actions.push(actioninfo2);

    let startDate = new Date();
    let endDate = new Date();
    endDate.setDate(startDate.getDate()+1);

    test_workoutBuilder
      .setPlanID('16,33,86') //以下两项为固定设置
      .setPlanState('NotStarted')
      .setUserID('1') //根据真实值传入
      .setPlanName('测试健身计划')  //以下方法当用户修改时可以再次调用传入新值
      .setCoverPicture('url:test')
      .setStartDate(startDate)
      .setEndDate(endDate)
      .setDayOfWeek("1#2#3")
      .setDescription("这是更新后的健身计划");
    test_workoutBuilder
      .setRestTimeBetweenSets(2)//下面属性设置只能直接跟在test_workoutBuilder后面调用
      .setRestTimeBetweenExercises(3)
      .setTag("健身#力量#有氧");
    test_workoutBuilder
      .addActions(actions) ;  //在提交按钮回调中进行以下函数的调用；（即传入的动作需要为最终确定的不可修再改的值）
    test_workoutBuilder
      .setTotalTime(this.getTotalTime())  //需要实现一个方法来计算总时间
      .build();//调用build方法返回完整对象
    let test_workoutPlan = new workoutPlan(test_workoutBuilder);
    this.ex.updatePlan(test_workoutPlan);
  }

  uploadPlan(){
    let test_workoutBuilder= this.ex.createPlanBuilder();
    //初始化动作
    let actioninfo: actionInfo = new actionInfo();
    actioninfo.ActionName ='动作1'; //所选动作填入
    actioninfo.ActionID = '111'; //所选动作填入
    actioninfo.Sets = 3;
    actioninfo.SingleSetNum =5 ;

    let actions: actionInfo[] = [];//创建空数组
    actions.push(actioninfo);//放入确定好的动作
    let actioninfo2: actionInfo = new actionInfo(); //代表加入另一个新动作，必须要new一个新对象，不可以复用之前的对象
    actioninfo2.ActionName ='动作2'; //所选动作填入
    actioninfo2.ActionID = '222'; //所选动作填入
    actioninfo2.Sets = 4;
    actioninfo2.SingleSetNum =5 ;
    actions.push(actioninfo2);

    let startDate = new Date();
    let endDate = new Date();
    endDate.setDate(startDate.getDate()+1);

    test_workoutBuilder
      .setPlanID(UUIDGenerator.getID()) //以下两项为固定设置
      .setPlanState('NotStarted')
      .setUserID('1') //根据真实值传入
      .setPlanName('测试健身计划')  //以下方法当用户修改时可以再次调用传入新值
      .setCoverPicture('url:test')
      .setStartDate(startDate)
      .setEndDate(endDate)
      .setDayOfWeek("1#2#3")
      .setDescription("这是一个测试健身计划");
    test_workoutBuilder
      .setRestTimeBetweenSets(2)//下面属性设置只能直接跟在test_workoutBuilder后面调用
      .setRestTimeBetweenExercises(3)
      .setTag("健身#力量");
    test_workoutBuilder
      .addActions(actions) ;  //在提交按钮回调中进行以下函数的调用；（即传入的动作需要为最终确定的不可修再改的值）
    test_workoutBuilder
      .setTotalTime(this.getTotalTime())  //需要实现一个方法来计算总时间
      .build();//调用build方法返回完整对象
    let test_workoutPlan = new workoutPlan(test_workoutBuilder);
    this.ex.uploadPlan(test_workoutPlan).then((result) => {
      if(result)
        hilog.info(1,"上传","上传计划成功");
      else
        hilog.error(1,'上传','上传错误');
    }
    ).catch((error: BusinessError) => {
      hilog.error(2,"上传错误",error.message);
    });
  }

  getTotalTime(): number {
    //遍历所有动作计算总耗时
    // let time = 0;
    // for(let action of this.includedActions){
    //   let time1 = action.TimeOfOne * action.basicInfo.SingleSetNum;
    //   let time2 = (action.basicInfo.Sets-1)* plan.RestTimeBetweenSets;
    //   time += time1;
    //   time += time2;
    //   time+= plan.RestTimeBetweenExercises;
    // }
    return 100;
  }

}

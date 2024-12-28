import {UUIDGenerator} from "utils"
import {ExercisePlanService,RunningPlanService,WorkoutPlanService,ActionRepository,Action,ActionFactory} from "exercise"
import {UserAchievementService,Achievement,achievement,ExerciseStates,userExerciseStates,
  UserExerciseStatsService,BodyDataTrackerService,AthleticAbility,athleticAbility,AthleticAbilityService} from "mine"
import {actionInfo,exercisePlan,runningPlan,workoutPlan,PlanBuilder,runningPlanBuilder,workoutPlanBuilder} from "exercise"
import { BusinessError } from "@kit.BasicServicesKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import {WorkoutPlan} from "exercise"
import {DateConverToNum}from "utils"//负责转换时间
import {PlanTask} from "exercise"
import { cloudFunction } from "@kit.CloudFoundationKit";
import {fetchDashscopeResponse,createWebSocketConnection} from "utils"
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
  @State todayTasksString: string = '';
  @State userAchievement: Achievement[] = [];
  @State userAchievementString: string = '';
  @State Achievement: Achievement [] = [];
  @State AchievementString: string = '';
  @State userExerciseStats: ExerciseStates [] = [];
  @State userExerciseStatsString: string = '';
  @State Action: Action[] |boolean = [];
  @State ActionString: string = '';
  @State Time: number = 0;
  @State Answer: string = '';
  ex: WorkoutPlanService = WorkoutPlanService.getInstance();
  exByCYB: UserAchievementService = UserAchievementService.getInstance();
  ex1: UserExerciseStatsService = UserExerciseStatsService.getInstance();
  ex2: BodyDataTrackerService = BodyDataTrackerService.getInstance();
  ex3: AthleticAbilityService = AthleticAbilityService.getInstance();
  ex4: ActionRepository=ActionRepository.getInstance();

  build() {
    Column() {
      Button('上传计划')
        .onClick(async () => {
          const response =  await fetchDashscopeResponse("我这个健身动作是杠零推胸，请你提供给我关于这个动作的动作指导");
          this.Answer=response;
        })
      Text(this.Answer);

      Button('查询所有胸部动作')
        .onClick(async () => {
         this.ex4.getAllAction().then((result) => {
                  if(result) {
                    hilog.info(1, "查询腹部", "查询成功");
                    this.Action = result ;
                    this.ActionString=JSON.stringify(this.Action);
                  }
                  else
                    hilog.error(1,'查询腹部','查询失败');
                }
                ).catch((error: BusinessError) => {
                  hilog.error(2,"查询失败",error.message);
                });
        })
      Text(this.ActionString);

      Button('查询用户动作')
        .onClick(async () => {
          this.ex4.getMyAction("b11").then((result) => {
            if(result) {
              hilog.info(1, "查询用户动作", "查询成功");
              this.Action = result ;
              this.ActionString=JSON.stringify(this.Action);
            }
            else
              hilog.error(1,'查询用户动作','查询失败');
          }
          ).catch((error: BusinessError) => {
            hilog.error(2,"查询失败",error.message);
          });
        })
      Text(this.ActionString);

      Button('新增用户动作')
        .onClick(async () => {
          let action =ActionFactory.createArmsAction();
          let actioninfo: actionInfo = new actionInfo()
          actioninfo.ActionName ='飞鸟'; //所选动作填入
          actioninfo.ActionID = '444'; //所选动作填入
          actioninfo.Sets = 4;
          actioninfo.SingleSetNum =5 ;
          action.basicInfo=actioninfo;
          this.ex4.addNewAction(action,"User1").then((result) => {
            if(result) {
              hilog.info(1, "新增用户动作", "增加成功");
              this.Action = result ;
              this.ActionString=JSON.stringify(this.Action);
            }
            else
              hilog.error(1,'新增用户动作','增加失败');
          }
          ).catch((error: BusinessError) => {
            hilog.error(2,"增加失败",error.message);
          });
        })


      Button('上传计划')
        .onClick(async () => {
          await createWebSocketConnection("1231c6qq","1. 传输方式不同\n" +
            "\n" +
            "流式传输是一种连续的传输方式，数据流在传输过程中是分片逐个传输的。而非流式传输则是将整个数据文件一次性传输的方式。\n" +
            "\n" +
            "2. 带宽利用率不同\n" +
            "\n" +
            "流式传输可以更好地利用网络带宽，每个数据块可以及时传输，节省传输时间。而非流式传输则要等待整个数据文件传输完成才能进行处理，导致传输时间较长。\n" +
            "\n" +
            "3. 错误处理不同\n" +
            "\n" +
            "流式传输可以较快地发现和处理错误，如果某个数据块不存在或者传输错误，只需要重传该块，不会影响其它部分。而非流式传输则需要重新传输整个数据文件。");
        })

    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}

//   updatePlan(){
//     let test_workoutBuilder= this.ex.createPlanBuilder();
//     //初始化动作
//     let actioninfo: actionInfo = new actionInfo();
//     actioninfo.ActionName ='动作3'; //所选动作填入
//     actioninfo.ActionID = '333'; //所选动作填入
//     actioninfo.Sets = 3;
//     actioninfo.SingleSetNum =5 ;
//
//     let actions: actionInfo[] = [];//创建空数组
//     actions.push(actioninfo);//放入确定好的动作
//     let actioninfo2: actionInfo = new actionInfo(); //代表加入另一个新动作，必须要new一个新对象，不可以复用之前的对象
//     actioninfo2.ActionName ='动作4'; //所选动作填入
//     actioninfo2.ActionID = '444'; //所选动作填入
//     actioninfo2.Sets = 4;
//     actioninfo2.SingleSetNum =5 ;
//     actions.push(actioninfo2);
//
//     let startDate = new Date();
//     let endDate = new Date();
//     endDate.setDate(startDate.getDate()+1);
//
//     test_workoutBuilder
//       .setPlanID('16,33,86') //以下两项为固定设置
//       .setPlanState('NotStarted')
//       .setUserID('1') //根据真实值传入
//       .setPlanName('测试健身计划')  //以下方法当用户修改时可以再次调用传入新值
//       .setCoverPicture('url:test')
//       .setStartDate(startDate)
//       .setEndDate(endDate)
//       .setDayOfWeek("1#2#3")
//       .setDescription("这是更新后的健身计划");
//     test_workoutBuilder
//       .setRestTimeBetweenSets(2)//下面属性设置只能直接跟在test_workoutBuilder后面调用
//       .setRestTimeBetweenExercises(3)
//       .setTag("健身#力量#有氧");
//     test_workoutBuilder
//       .addActions(actions) ;  //在提交按钮回调中进行以下函数的调用；（即传入的动作需要为最终确定的不可修再改的值）
//     test_workoutBuilder
//       .setTotalTime(this.getTotalTime())  //需要实现一个方法来计算总时间
//       .build();//调用build方法返回完整对象
//     let test_workoutPlan = new workoutPlan(test_workoutBuilder);
//     this.ex.updatePlan(test_workoutPlan);
//   }
//
//   uploadPlan(){
//     let test_workoutBuilder= this.ex.createPlanBuilder();
//     //初始化动作
//     let actioninfo: actionInfo = new actionInfo();
//     actioninfo.ActionName ='动作1'; //所选动作填入
//     actioninfo.ActionID = '111'; //所选动作填入
//     actioninfo.Sets = 3;
//     actioninfo.SingleSetNum =5 ;
//
//     let actions: actionInfo[] = [];//创建空数组
//     actions.push(actioninfo);//放入确定好的动作
//     let actioninfo2: actionInfo = new actionInfo(); //代表加入另一个新动作，必须要new一个新对象，不可以复用之前的对象
//     actioninfo2.ActionName ='动作2'; //所选动作填入
//     actioninfo2.ActionID = '222'; //所选动作填入
//     actioninfo2.Sets = 4;
//     actioninfo2.SingleSetNum =5 ;
//     actions.push(actioninfo2);
//
//     let startDate = new Date();
//     let endDate = new Date();
//     endDate.setDate(startDate.getDate()+1);
//
//     test_workoutBuilder
//       .setPlanID(UUIDGenerator.getID()) //以下两项为固定设置
//       .setPlanState('NotStarted')
//       .setUserID('1') //根据真实值传入
//       .setPlanName('测试健身计划')  //以下方法当用户修改时可以再次调用传入新值
//       .setCoverPicture('url:test')
//       .setStartDate(startDate)
//       .setEndDate(endDate)
//       .setDayOfWeek("1#2#3")
//       .setDescription("这是一个测试健身计划");
//     test_workoutBuilder
//       .setRestTimeBetweenSets(2)//下面属性设置只能直接跟在test_workoutBuilder后面调用
//       .setRestTimeBetweenExercises(3)
//       .setTag("健身#力量");
//     test_workoutBuilder
//       .addActions(actions) ;  //在提交按钮回调中进行以下函数的调用；（即传入的动作需要为最终确定的不可修再改的值）
//     test_workoutBuilder
//       .setTotalTime(this.getTotalTime())  //需要实现一个方法来计算总时间
//       .build();//调用build方法返回完整对象
//     let test_workoutPlan = new workoutPlan(test_workoutBuilder);
//     this.ex.uploadPlan(test_workoutPlan).then((result) => {
//       if(result)
//         hilog.info(1,"上传","上传计划成功");
//       else
//         hilog.error(1,'上传','上传错误');
//     }
//     ).catch((error: BusinessError) => {
//       hilog.error(2,"上传错误",error.message);
//     });
//   }
//
//   getTotalTime(): number {
//     //遍历所有动作计算总耗时
//     // let time = 0;
//     // for(let action of this.includedActions){
//     //   let time1 = action.TimeOfOne * action.basicInfo.SingleSetNum;
//     //   let time2 = (action.basicInfo.Sets-1)* plan.RestTimeBetweenSets;
//     //   time += time1;
//     //   time += time2;
//     //   time+= plan.RestTimeBetweenExercises;
//     // }
//     return 100;
//   }
//
//   //测试成就,getAchievementmedal(uid: string)
//   UserGetAchievement(){
//     let achievementID="123";
//     let medalName="GOAT";
//     let currentDate=new Date();
//     let Image='';
//     let des="这是一枚GOAT徽章";
//     let newAchievement:achievement= achievement.create(achievementID,medalName,currentDate,Image,des);
//     this.exByCYB.addAchievement(newAchievement,"User2").then((result) => {
//       if(result)
//         hilog.info(1,"上传","获得荣誉成功");
//       else
//         hilog.error(1,'上传','获得荣誉失败');
//     }
//     ).catch((error: BusinessError) => {
//       hilog.error(2,"获得荣誉失败",error.message);
//     });
//
//   }
//
//   //测试更新用户运动状态
//   updateUserExerciseStates(){
//     let totalSteps=9;
//     let totalTime=9;//以min为单位
//     let calories=9;
//     let TimeStamp=new Date();
//     let newuserExerciseStates:userExerciseStates= userExerciseStates.create(totalSteps,totalTime,calories,TimeStamp);
//
//     this.ex1.updateUserExerciseStates(newuserExerciseStates,"User1").then((result) => {
//       if(result)
//         hilog.info(1,"更新","更新成功");
//       else
//         hilog.error(1,'更新','更新失败');
//     }
//     ).catch((error: BusinessError) => {
//       hilog.error(2,"更新失败",error.message);
//     });
//
//   }
//
//
//   //updateInfo
//   updateInfo(){
//     let run=100;
//     let push=10;
//     let squa=0;
//     let cruch=5;
//     let record:athleticAbility=athleticAbility.create(run,push,squa,cruch);
//     this.ex3.updateInfo(record,"User1").then((result) => {
//       if(result)
//         hilog.info(1,"上传","更新成功");
//       else
//         hilog.error(1,'上传','更新失败');
//     }
//     ).catch((error: BusinessError) => {
//       hilog.error(2,"更新失败",error.message);
//     });
//   }
//
//
//
//
// }
// Button('上传计划')
//   .onClick(() =>{
//     this.uploadPlan();
//   })
//
// Button('更新计划')
//   .onClick(()=>{
//     this.updatePlan();
//   })
//
// Button('删除计划')
//   .onClick(()=>{
//     this.ex.deletePlan('16,33,86');
//   })
//
// Button('获取今日任务')  //会返回所有今天的任务，未做已完成、已放弃、待完成区分，可以利用State字段实现
//   .onClick(()=>{
//    this.ex.getTodayTasks('1').then((result:WorkoutPlan[])=>{
//      this.todayTasks = result; //可以直接使用这个变量进行后续展示处理
//      this.todayTasksString  = JSON.stringify(result);
//     }
//    )
//   })
// Text(this.todayTasksString)
//
// Button('完成任务')
//   .onClick(()=>{
//     this.ex.finishTask('121,152,16')
//   })
//
// Button('放弃任务')
//   .onClick(()=>{
//     this.ex.abandonTask('145,130,93')
//   })
//
//
// Button('返回用户所有荣誉')
//   .onClick(() =>{
//     this.exByCYB.getAchievementmedal("User2").then((result:Achievement[])=>{
//       this.userAchievement = result; //可以直接使用这个变量进行后续展示处理
//       this.userAchievementString  = JSON.stringify(result);
//   })
//   })
// Text(this.userAchievementString)
//
// Button('根据荣誉ID查找荣誉')
//   .onClick(() =>{
//     this.exByCYB.findAchievementByID("123456").then((result:Achievement)=>{
//       this.Achievement[0] = result; //可以直接使用这个变量进行后续展示处理
//       this.AchievementString  = JSON.stringify(result);
//     })
//   })
// Text(this.AchievementString)
//
// //工具函数时间适用样例
// Button('打印时间')
//   .onClick(() =>{
//     let time=new Date();
//     this.Time=DateConverToNum.convertDateToInteger(time);
//     })
// Text(this.Time.toString());
//
// Button('用户获得荣誉')
//   .onClick(() => {
//     this.UserGetAchievement();})
//
// Button('用户更新当日运动状态')
//   .onClick(() => {
//     this.updateUserExerciseStates();})
//
// Button('用户获取指定日期的运动状态')
//   .onClick(() => {
//     this.ex1.getUserExerciseStates("User1",20241108);})
// //this.text = UUIDGenerator.getID(); let uid:string="User1";
// //     this.ex2.getLatestWeightData(uid)
// Button('获取用户最新的体重数据')
//   .onClick(() => {
//     let uid:string="User1";
//     this.ex2.getLatestWeightData(uid);})
//
// Button('获取用户身高数据')
//   .onClick(() => {
//     let uid:string="User1";
//     this.ex2.getUserHeight(uid);})
//
// Button('获取用户身高数据')
//   .onClick(() => {
//     let uid:string="User1";
//     this.ex2.modifyheight(uid,172);})
// //addWeight
// // Button('增加体重数据')
// //   .onClick(() => {
// //     let uid:string="User1";
// //     this.ex2.addWeight(uid,75);})
// //
// // Button('增加体脂数据')
// //   .onClick(() => {
// //     let uid:string="User1";
// //     this.ex2.addBodyFatRate(uid,75);})
// //
// // //getWeightHistory
// // Button('查看历史体重数据')
// //   .onClick(() => {
// //     let uid:string="User1";
// //     this.ex2.getWeightHistory(uid);})
//
// // Button('查看历史体重数据')
// //   .onClick(() => {
// //     let uid:string="User1";
// //     this.ex2.getBodyFatRateHistory(uid);})

// Button('查看历史体重数据')
//   .onClick(() => {
//     this.ex3.getInfoByUserID("User1");})




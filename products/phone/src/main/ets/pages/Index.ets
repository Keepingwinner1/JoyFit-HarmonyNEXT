import {UUIDGenerator} from "utils"
import {ExercisePlanService,RunningPlanService,WorkoutPlanService,ActionRepository} from "exercise"
import {actionInfo,exercisePlan,runningPlan,workoutPlan,PlanBuilder,runningPlanBuilder,workoutPlanBuilder} from "exercise"
import { BusinessError } from "@kit.BasicServicesKit";
import { hilog } from "@kit.PerformanceAnalysisKit";

@Entry
@Component
struct Index {
  @State text: string = ''
  ex: WorkoutPlanService = WorkoutPlanService.getInstance();

  build() {
    Column() {
      Text(this.text)

      Button('测试')
        .onClick(() =>{
           let test_workoutBuilder= this.ex.createPlanBuilder();
           //初始化动作
           let actioninfo: actionInfo = new actionInfo();
            actioninfo.ActionName ='动作1'; //所选动作填入
            actioninfo.ActionID = '111'; //所选动作填入
            actioninfo.Sets = 3;
            actioninfo.SingleSetNum =5 ;

            let actions: actionInfo[] = [];//创建空数组
            actions.push(actioninfo);//放入确定好的动作
            actions.push(actioninfo);

           test_workoutBuilder
             .setPlanID(UUIDGenerator.getID()) //以下两项为固定设置
             .setPlanState('NotStarted')
             .setUserID('1') //根据真实值传入
             .setPlanName('测试健身计划')  //以下方法当用户修改时可以再次调用传入新值
             .setCoverPicture('url:test')
             .setStartDate(new Date())
             .setEndDate(new Date())
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
            this.ex.uploadPlan(test_workoutPlan,"1").then((result) => {
              if(result)
                hilog.info(1,"上传","上传计划成功");
              else
                hilog.error(1,'上传','上传错误');
            }
            ).catch((error: BusinessError) => {
              hilog.error(2,"上传错误",error.message);
            });
          //this.text = UUIDGenerator.getID();
        })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
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

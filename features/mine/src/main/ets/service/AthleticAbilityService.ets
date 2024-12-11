import {AthleticAbility} from "../model/AthleticAbility"

class AthleticAbilityService{
  private instance: AthleticAbilityService|null = null;
  private athleticAbility: AthleticAbility  = AthleticAbility.createFromCloud();

  // 更新运动能力信息的方法
  // userID 用来识别特定的用户，可以在实际应用中用于关联数据库中的用户
  public updateInfo(newAthleticAbilityInfo: AthleticAbility, userID: number): boolean {
    // 假设我们会根据 userID 查找用户的现有数据，并更新（这里只是简单示范）
    console.log(`Updating athletic ability info for user ID: ${userID}`);

    this.athleticAbility.runningDistance
    // 将新的运动能力信息赋给当前实例

    // this.athleticAbility.runningDistance = newAthleticAbilityInfo.runningDistance;
    // this.pushUpNums = newAthleticAbilityInfo.pushUpNums;
    // this.squatNums = newAthleticAbilityInfo.squatNums;
    // this.crunchNums = newAthleticAbilityInfo.crunchNums;

    console.log('Athletic ability info updated successfully!');
    return true; // 表示更新成功
  }
}

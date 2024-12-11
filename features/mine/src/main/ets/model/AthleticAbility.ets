export class AthleticAbility {
  // 属性字段
  private _runningDistance: number;  // 跑步距离 (以公里为单位)
  private _pushUpNums: number;       // 俯卧撑数量
  private _squatNums: number;        // 深蹲次数
  private _crunchNums: number;       // 仰卧起坐次数

  private constructor(runningDistance: number, pushUpNums: number, squatNums: number, crunchNums: number) {
    this._runningDistance = runningDistance;
    this._pushUpNums = pushUpNums;
    this._squatNums = squatNums;
    this._crunchNums = crunchNums;
  }

  get runningDistance(): number{
    return this._runningDistance;
  }
  set runningDistance(value: number){
    //可以添加验证逻辑
    this._runningDistance =value;
  }

  get pushUpNums(): number{
    return this._pushUpNums;
  }
  set pushUpNums(value: number){
    //可以添加验证逻辑
    this._pushUpNums =value;
  }

  get squatNums(): number{
    return this._squatNums;
  }
  set squatNums(value: number){
    //可以添加验证逻辑
    this._squatNums =value;
  }

  get crunchNums(): number{
    return this._crunchNums;
  }
  set crunchNums(value: number){
    //可以添加验证逻辑
    this._crunchNums =value;
  }

  static create(runningDistance: number, pushUpNums: number, squatNums: number, crunchNums: number):AthleticAbility{
    return new AthleticAbility(runningDistance, pushUpNums, squatNums, crunchNums);
  }

  static createFromCloud(): AthleticAbility{
    //具体获取逻辑
    return new AthleticAbility();
  }
}

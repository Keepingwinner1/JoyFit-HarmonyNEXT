export class userExerciseStates {
  private _totalSteps:number;
  private _totalExerciseTime:number;
  private _totalCalorisesBurned:number;
  private _timeStamp:Date;

  private constructor(totalSteps:number,totalExerciseTime:number,totalCalorisesBurned:number,timeStamp:Date) {
    this._totalSteps = totalSteps;
    this._totalExerciseTime =totalExerciseTime;
    this._totalCalorisesBurned =totalCalorisesBurned;
    this._timeStamp= timeStamp;
  }

  get totalSteps():number{
    return this._totalSteps;
  }

  set totalSteps(value:number){
    if(value>=0) {
      this._totalSteps = value;
    }
    else{
      this._totalSteps =0;
    }
  }

  get totalExerciseTime():number{
    return this._totalExerciseTime;
  }

  set totalExerciseTime(value:number){
    if(value>=0) {
      this._totalExerciseTime = value;
    }
    else{
      this._totalExerciseTime =0;
    }
  }

  get totalCalorisesBurned():number{
    return this._totalCalorisesBurned;
  }

  set totalCalorisesBurned(value:number){
    if(value>=0) {
      this._totalCalorisesBurned = value;
    }
    else{
      this._totalCalorisesBurned =0;
    }
  }

  get timeStamp():Date{
    return this._timeStamp;
  }

  set timeStamp(value:Date){
    //检查是否为有效日期
    if (isNaN(value.getTime())) {
      throw new Error("Invalid date provided to timeStamp");
    }
    this._timeStamp = value;
  }

  static create(totalSteps:number,totalExerciseTime:number,totalCalorisesBurned:number,timeStamp:Date):userExerciseStates{
    return new userExerciseStates(totalSteps,totalExerciseTime,totalCalorisesBurned,timeStamp );
  }

}

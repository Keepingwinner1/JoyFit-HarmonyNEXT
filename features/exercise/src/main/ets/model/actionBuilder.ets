import {action} from './action'
import {actionInfo} from './action'


export class actionBuilder {
  private _basicInfo: actionInfo;
  private _introductionVideo: string;
  private _introductionVoice: string;
  private _description: string;
  private _timeOfOne: number;
  private _mainTrainingPart: string;
  private _isUserDefined: boolean;
  private _calories: number;


  constructor(type:string) {
    this._basicInfo = new actionInfo('','',type,0,0);
    this._introductionVideo='';
    this._introductionVoice='';
    this._description='';
    this._timeOfOne=0;
    this._mainTrainingPart='';
    this._isUserDefined=false;
    this._calories=0;
  }

  sets(num: number):actionBuilder {
    this._basicInfo.Sets = num;
    return this;
  }

  singleSetNum(num: number):actionBuilder {
    this._basicInfo.SingleSetNum = num;
    return this;
  }

  introductionVideo(videoUrl: string):actionBuilder {
    this._introductionVideo = videoUrl;
    return this;
  }

  introductionVoice(voiceUrl: string):actionBuilder {
    this._introductionVoice = voiceUrl;
    return this;
  }

  description(desc: string):actionBuilder {
    this._description = desc;
    return this;
  }

  timeOfOne(time: number) :actionBuilder{
    this._timeOfOne = time;
    return this;
  }

  mainTrainingPart(part: string):actionBuilder {
    this._mainTrainingPart = part;
    return this;
  }

  isUserDefined(isTrue: boolean):actionBuilder {
    this._isUserDefined = isTrue;
    return this;
  }

  calories(calories:number):actionBuilder{
    this._calories=calories;
    return this;
  }

  public build(): action {
    return new action(
      this._basicInfo,
      this._introductionVideo,
      this._introductionVoice,
      this._description,
      this._timeOfOne,
      this._mainTrainingPart,
      this._isUserDefined,
      this._calories,
    );
  }
}



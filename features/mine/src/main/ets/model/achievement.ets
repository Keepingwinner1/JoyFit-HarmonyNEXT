
export class achievement {
  private _achievementID: string;
  private _medalName: string;
  private _achieveTime: Date;
  private _medalImage: string;
  private _description: string;

  constructor(achievementID: string, medalName: string, achieveTime: Date, medalImage: string, description: string) {
    this._achievementID = achievementID;
    this._medalName = medalName;
    this._achieveTime = achieveTime;
    this._medalImage = medalImage;
    this._description = description;
  }

   getAchievementID(): string {
    return this._achievementID;
  }

  setAchievementID(id: string): void {
    this._achievementID = id;
  }

  getMedalName(): string {
    return this._medalName;
  }

  setMedalName(name: string): void {
    this._medalName = name;
  }

  getAchieveTime(): Date {
    return this._achieveTime;
  }

  setAchieveTime(time: Date): void {
    this._achieveTime = time;
  }

  getMedalImage(): string {
    return this._medalImage;
  }

  setMedalImage(image: string): void {
    this._medalImage = image;
  }

  getDescription(): string {
    return this._description;
  }

  setDescription(desc: string): void {
    this._description = desc;
  }

  static create(achievementID:string,medalName:string,achieveTime:Date,medalImage:string,description:string):achievement{
    return new achievement(achievementID, medalName, achieveTime, medalImage, description);
  }


}

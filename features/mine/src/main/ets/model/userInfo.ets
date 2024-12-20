
export class userInfo{
  private _nickname: string;
  private _avtar:string;
  private _age:number;
  private _sex:string;
  private _city:string;

  private constructor(nickname:string,avtar:string,age:number,sex:string,city:string) {
      this._nickname = nickname;
      this._avtar =avtar;
      this._age =age;
      this._sex= sex;
      this._city = city;
  }
  get nickname(): string{
    return this._nickname;
  }
  set nickname(value: string){
    //可以添加验证逻辑
    this._nickname =value;
  }

  get avtar(): string{
    return this._avtar;
  }
  set avtar(value: string){
    //可以添加验证逻辑
    this._avtar =value;
  }

  get age(): number{
    return this._age;
  }
  set age(value: number){
    //可以添加验证逻辑
    this._age =value;
  }

  get sex(): string{
    return this._sex;
  }
  set sex(value: string){
    //可以添加验证逻辑
    this._sex =value;
  }

  get city(): string{
    return this._city;
  }

  set city(value: string){
    this._city =value;
  }

  static create(nickname:string,avtar:string,age:number,sex:string,city:string):userInfo{
    return new userInfo(nickname, avtar, age, sex, city);
  }

  // static createFromCloud(): UserInfo {
  //
  //
  // }

}

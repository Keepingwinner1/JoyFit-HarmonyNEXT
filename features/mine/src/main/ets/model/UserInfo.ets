
export class UserInfo{
  private nickname: string;
  private avtar:string;
  private age:number;
  private sex:string;
  private city:string;

  private constructor(nickname:string,avtar:string,age:number,sex:string,city:string) {
      this.nickname = nickname;
      this.avtar =avtar;
      this.age =age;
      this.sex= sex;
      this.city = city;
  }

  // static createFromCloud(): UserInfo {
  //
  //
  // }

}

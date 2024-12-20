
export default class AccountInfo{
  //accountID?: string;
  phoneNumber?: string;
  password?: string;
  verifyingCode?: string;

  consturctor(phoneNumber:string,password ?:string,verifyingCode:string="-1"){
    this.phoneNumber=phoneNumber;
    if(password!= undefined)
      this.password = password;
    this.verifyingCode =verifyingCode;
  }
}

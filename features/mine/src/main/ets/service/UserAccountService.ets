import auth, { AGCAuthError, AuthUser } from '@hw-agconnect/auth';
import  AccountInfo  from '../model/AccountInfo'
import { UserInfo } from '../model/UserInfo'
import { VerifyCodeAction } from '@hw-agconnect/auth';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { cloudCommon } from '@kit.CloudFoundationKit';

export class UserAccountService {
  //private account: AccountInfo = AccountInfo.createFromCloud();
  private static instance: UserAccountService | null = null;

  private constructor() {}

  static getInstance(): UserAccountService {
    if (!UserAccountService.instance) {
      UserAccountService.instance = new UserAccountService();
    }
    return UserAccountService.instance;
  }


  sendVerifyCode(phoneNumber:string): boolean {
    auth.requestVerifyCode({
      action: VerifyCodeAction.REGISTER_LOGIN,
      lang: 'zh_CN',
      sendInterval: 60,
      verifyCodeType: {
        phoneNumber: phoneNumber,
        countryCode: "86",
        kind: "phone",
      }
    }).then(verifyCodeResult => {
      // 验证码申请成功
        return true;
    }).catch((error: Error) => {
      // 验证码申请失败
      //hilog.info(error.message)
      return false;
    })
    return false;
  }

  register(account: AccountInfo): AuthUser | boolean {
    auth.createUser({
      kind: 'phone',
      countryCode: '86',
      phoneNumber: account.phoneNumber,
      password: account.password,//可以给用户设置初始密码。后续可以用密码来登录
      verifyCode: account.verifyingCode
    }).then(result => {
      //创建账号成功后，系统会自动登录，无需再次调用登录接口
      //向数据库插入注册用户信息


      return result.getUser();
    }).catch(()=>{
      console.log("Registration failed: Invalid verification code");
      return false;
    }
    )
    return false;
  }

  //在应用的登录界面，初始化Auth实例，获取AGC的用户信息，检查是否有已经登录的用户。
  // 如果有，则可以直接进入用户界面，否则显示登录界面。
  // auth.getCurrentUser().then(user=>{
  //   if(user){
  //     //业务逻辑
  //   }
  // });

  login(account: AccountInfo,loginType:string): AuthUser | boolean {
    switch(loginType){
      case "password" :
        auth.signIn({
          credentialInfo: {
            kind: 'phone',
            phoneNumber: account.phoneNumber,
            countryCode: '86',
            password: account.password
          }
        }).then(user => {
          //登录成功
          let provider =  auth.getAuthProvider();
          cloudCommon.init({authProvider: provider});

          return user.getUser();
        }).catch((error:Error) => {
          //登录失败
          console.error("test", "signIn error: "+ loginType + error)
        });
        break;
      case "verifyCode":
        auth.signIn({
          credentialInfo: {
            kind: 'phone',
            phoneNumber: account.phoneNumber,
            countryCode: '86',
            verifyCode: account.verifyingCode
          }
        }).then(user => {
          //登录成功
          let provider =  auth.getAuthProvider();
          cloudCommon.init({authProvider: provider});
          return user.getUser();
        }).catch((error: Error) => {
          // if(error instanceof AGCAuthError){
          //   //if(error.code == 203817986)
          // }
          //登录失败
          console.error("test", "signIn error: "+ loginType + error)
          return false;
        });
        break;
        case "huaiweiID":
          auth.signIn({
            autoCreateUser: true,
            "credentialInfo": {
              "kind": "hwid"
            }
          })
            .then(signInResult => {
              console.info("test", "signInHwid success " + signInResult.getUser().getUid());
              let provider =  auth.getAuthProvider();
              cloudCommon.init({authProvider: provider});
              return  signInResult.getUser()
            })
            .catch((error: Error) => {
              console.error("test", "signInHwid error " + error);
              return false;
            })
          break;
    }
    return false;
  }

  updateUserInfo(userInfo: UserInfo): void {
    //

  }
}

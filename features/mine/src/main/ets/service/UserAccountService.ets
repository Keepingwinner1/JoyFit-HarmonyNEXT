import auth, { AGCAuthError, AuthUser } from '@hw-agconnect/auth';
import  {accountInfo}  from '../model/accountInfo'
import { UserInfo } from '../bean/UserInfo';
import { AccountInfo } from '../bean/AccountInfo';
import  {userInfo}  from '../model/userInfo';
import { VerifyCodeAction } from '@hw-agconnect/auth';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { cloudCommon, cloudDatabase,cloudStorage } from '@kit.CloudFoundationKit';
import {UUIDGenerator} from 'utils'

const bucket: cloudStorage.StorageBucket = cloudStorage.bucket();

export class UserAccountService {
  //private account: AccountInfo = AccountInfo.createFromCloud();
  private static instance: UserAccountService | null = null;
  private agcDataBase: cloudDatabase.DatabaseZone = cloudDatabase.zone('joyfit');


  private constructor() {}

  static getInstance(): UserAccountService {
    if (!UserAccountService.instance) {
      UserAccountService.instance = new UserAccountService();
    }
    return UserAccountService.instance;
  }

  //构造一个 newUserInfo 对象
  private createUserInfo(userInfo: userInfo, uid: string): UserInfo {
    let newUserInfo = new UserInfo();
    newUserInfo.UserID = uid;
    newUserInfo.NickName = userInfo.nickname;
    newUserInfo.Avtar = userInfo.avtar;
    newUserInfo.Age = userInfo.age;
    newUserInfo.Sex = userInfo.sex;
    newUserInfo.City = userInfo.city;

    return newUserInfo;
  }

  private createAccountInfo(newaccountInfo: accountInfo, uid: string): AccountInfo {
    let newaccount = new AccountInfo();
    newaccount.AccountInfoID=UUIDGenerator.getID();
    newaccount.PhoneNumber=newaccountInfo.phoneNumber;
    newaccount.PassWord=newaccountInfo.password;
    newaccount.AccountState='正常';
    newaccount.UserID=uid;

    return newaccount;
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

  async register(account: accountInfo): Promise<AuthUser | boolean> {
    try {
      // 创建用户
      const result = await auth.createUser({
        kind: 'phone',
        countryCode: '86',
        phoneNumber: account.phoneNumber,
        password: account.password, // 可以给用户设置初始密码。后续可以用密码来登录
        verifyCode: account.verifyingCode,
      });

      // 创建账号成功后，系统会自动登录，无需再次调用登录接口
      const uid = result.getUser().getUid();

      // 使用 syncupdateUserInfo 函数将用户信息插入数据库
      const newUserInfo = userInfo.create("默认用户名", '', 16, '', '');
      const updateResult1 = await this.syncupdateUserInfo(newUserInfo, uid);
      const updateResult2 = await this.syncupdateAccountInfo(account, uid);

      if (updateResult1 && updateResult2) {
        console.info(`UserInfo successfully inserted for UID: ${uid}`);
      } else {
        console.warn(`Failed to insert UserInfo for UID: ${uid}`);
      }

      // 返回注册成功的用户信息
      return result.getUser();
    } catch (error) {
      console.error("Registration failed:", error.message || "Invalid verification code");
      return false;
    }
  }


  //在应用的登录界面，初始化Auth实例，获取AGC的用户信息，检查是否有已经登录的用户。
  // 如果有，则可以直接进入用户界面，否则显示登录界面。
  // auth.getCurrentUser().then(user=>{
  //   if(user){
  //     //业务逻辑
  //   }
  // });

  login(account: accountInfo,loginType:string): AuthUser | boolean {
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


  //用户更新个人信息
  async syncupdateUserInfo(userInfo: userInfo, uid: string): Promise<boolean> {
    // 参数校验
    if (!userInfo || !uid) {
      console.error('Invalid parameters: userInfo or uid is missing');
      return false;
    }

    try {

      // 将用户信息转换为可插入/更新的数据结构
      let waitforUpdateUserInfo = this.createUserInfo(userInfo, uid);

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([waitforUpdateUserInfo]);

      if (num > 0) {
        console.info(`Successfully updated/inserted ${num} records.`);
        return true;
      } else {
        console.warn('No records were updated or inserted.');
        return false;
      }
    } catch (err) {
      // 错误处理
      console.error(`Failed to upsert, error: `, err);
      return false;
    }
  }

  //账户信息更新
  async syncupdateAccountInfo(accountinfo: accountInfo, uid: string): Promise<boolean> {
    // 参数校验
    if (!accountinfo || !uid) {
      console.error('Invalid parameters: userInfo or uid is missing');
      return false;
    }

    try {

      // 将用户信息转换为可插入/更新的数据结构
      let waitforUpdateAccountInfo = this.createAccountInfo(accountinfo,uid);

      // 调用 upsert 方法
      let num = await this.agcDataBase.upsert([waitforUpdateAccountInfo]);

      if (num > 0) {
        console.info(`Successfully updated/inserted ${num} records.`);
        return true;
      } else {
        console.warn('No records were updated or inserted.');
        return false;
      }
    } catch (err) {
      // 错误处理
      console.error(`Failed to upsert, error: `, err);
      return false;
    }
  }


}



//注册原方法
/*register(account: AccountInfo): AuthUser | boolean {
    auth.createUser({
      kind: 'phone',
      countryCode: '86',
      phoneNumber: account.phoneNumber,
      password: account.password,//可以给用户设置初始密码。后续可以用密码来登录
      verifyCode: account.verifyingCode
    }).then(result => {
      //创建账号成功后，系统会自动登录，无需再次调用登录接口
      let uid = result.getUser().getUid()
      //向数据库插入注册用户信息
      return result.getUser();
    }).catch(()=>{
      console.log("Registration failed: Invalid verification code");
      return false;
    }
    )
    return false;
  }*/

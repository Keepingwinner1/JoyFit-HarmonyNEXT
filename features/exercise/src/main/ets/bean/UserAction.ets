import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个Action的类继承cloudDatabase.DatabaseObject
class UserAction extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'UserAction';
  }

  public ActionID: string | undefined;
  public UserID: string | undefined;

}

export { UserAction };

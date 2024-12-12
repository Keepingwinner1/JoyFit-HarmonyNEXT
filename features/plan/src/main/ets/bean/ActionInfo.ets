import { cloudDatabase } from '@kit.CloudFoundationKit';

// 创建一个ActionInfo的类继承cloudDatabase.DatabaseObject
class ActionInfo extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return 'ActionInfo';
  }

  public ActionInfolD: string | undefined;  // String类型
  public ActionlD: string | undefined;  // String类型
  public Sets: number | undefined;  // Integer类型
}

export { ActionInfo };

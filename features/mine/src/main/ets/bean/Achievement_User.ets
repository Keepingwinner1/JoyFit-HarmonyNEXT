import { cloudDatabase } from '@kit.CloudFoundationKit';

export class Achievement_User extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'Achievement_User';
  }
  public AchievementID : string | undefined;
  public UserID : string| undefined;
  public AchieveTime: Date | undefined;

}

import { cloudDatabase } from '@kit.CloudFoundationKit';

export class Achievement extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'Achievement';
  }
  public AchievementID : string | undefined;
  public MedalName : string| undefined;
  public MedalImage: string | undefined;
  public Description : string | undefined;



}

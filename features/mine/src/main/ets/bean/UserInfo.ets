import { cloudDatabase } from '@kit.CloudFoundationKit';

export class UserInfo extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'UserInfo';
  }
  public UserID : string | undefined;
  public NickName : string| undefined;
  public Avtar: string | undefined;
  public Age : number | undefined;
  public Sex : string | undefined;
  public City : string | undefined;

}


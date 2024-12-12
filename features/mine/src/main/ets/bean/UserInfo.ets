import { cloudDatabase } from '@kit.CloudFoundationKit';

export class UserInfo extends cloudDatabase.DatabaseObject{

  public UserID : number | undefined;
  public NickName : string| undefined;
  public Avtar: string | undefined;
  public Age : number | undefined;
  public Sex : string | undefined;
  public City : string | undefined;

}

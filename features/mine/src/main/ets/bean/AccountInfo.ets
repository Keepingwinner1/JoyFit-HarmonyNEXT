import { cloudDatabase } from '@kit.CloudFoundationKit';

export class AccountInfo extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'AccountInfo';
  }
  public AccountInfoID : string | undefined;
  public UserID : string| undefined;
  public PhoneNumber: string | undefined;
  public PassWord : string | undefined;
  public AccountState: string | undefined;

}

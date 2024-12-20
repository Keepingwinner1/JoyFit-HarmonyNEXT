import { cloudDatabase } from '@kit.CloudFoundationKit';

export class BodyHeight extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'BodyHeight';
  }
  public UserID : string | undefined;
  public Height : number| undefined;
  public LastUpdateTime: Date | undefined;



}

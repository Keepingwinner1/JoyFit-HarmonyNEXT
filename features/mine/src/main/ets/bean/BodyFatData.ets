import { cloudDatabase } from '@kit.CloudFoundationKit';

export class BodyFatData extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'BodyFatData';
  }
  public UserID : string | undefined;
  public BodyFatRecordTime: number | undefined;
  public BodyFatRate : number| undefined;

}

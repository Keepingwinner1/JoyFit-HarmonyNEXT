import { cloudDatabase } from '@kit.CloudFoundationKit';

export class WeightData extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'WeightData';
  }
  public UserID : string | undefined;
  public WeightRecordTime: number | undefined;
  public Weight : number| undefined;
  public BMI: number | undefined;

}

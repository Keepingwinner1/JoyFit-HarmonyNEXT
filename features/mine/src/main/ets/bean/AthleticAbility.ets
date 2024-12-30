import { cloudDatabase } from '@kit.CloudFoundationKit';

export class AthleticAbility extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return 'AthleticAbility';
  }
  public UserID : string | undefined;
  public RunningDistance: number | undefined;
  public PushUpNums : number| undefined;
  public SquatNums : number| undefined;
  public CrunchNums : number| undefined;
  public LastUpdated : number| undefined;

}

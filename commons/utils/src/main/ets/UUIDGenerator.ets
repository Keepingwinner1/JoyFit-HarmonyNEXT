import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';


export class UUIDGenerator {
  public static getID(): string {
    let rand = cryptoFramework.createRandom();
    let len = 3; // Generate a 12-byte random number.  9位数字
    let randData = rand.generateRandomSync(len);
    //console.info("[Sync]: rand result: " + randData.data);
    return randData.data.toString();
  }
}

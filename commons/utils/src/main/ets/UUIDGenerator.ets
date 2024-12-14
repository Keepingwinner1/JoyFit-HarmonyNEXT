import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';


export class UUIDGenerator {
  public static getID(): string {
    let rand = cryptoFramework.createRandom();
    let len = 12; // Generate a 12-byte random number.
    let randData = rand.generateRandomSync(len);
    console.info("[Sync]: rand result: " + randData.data);
    return randData.data.toString();
  }
}



export class DateConverToNum {
  public static convertDateToInteger(date: Date): number {
    // 获取年份、月份和日期
    const year = date.getFullYear();
    const month = date.getMonth() + 1;  // 月份从0开始，所以要加1
    const day = date.getDate();

    // 格式化为 YYYYMMDD 格式
    const formattedDate = `${year}${month.toString().padStart(2, '0')}${day.toString().padStart(2, '0')}`;

    // 转换为整数并返回
    return parseInt(formattedDate);
  }
}



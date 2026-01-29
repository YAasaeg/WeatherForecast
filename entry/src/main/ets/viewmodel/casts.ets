export class casts{
  date: string
  week: number
  dayweather: string
  nightweather: string
  daytemp: number
  nighttemp: number
  daywind: string
  nightwind: string
  daypower: string
  nightpower: string
  daytemp_float: number
  nighttemp_float: number

  //构造函数
  constructor(  date: string, week: number, dayweather: string, nightweather: string, daytemp: number, nighttemp: number, daywind: string,
    nightwind: string, daypower: string, nightpower: string, daytemp_float: number, nighttemp_float: number) {
    this.date = date;
    this.week = week;
    this.dayweather = dayweather;
    this.nightweather = nightweather;
    this.daytemp = daytemp;
    this.nighttemp = nighttemp;
    this.daywind = daywind;
    this.nightwind = nightwind;
    this.daypower = daypower;
    this.nightpower = nightpower;
    this.daytemp_float = daytemp_float;
    this.nighttemp_float = nighttemp_float;
  }
}
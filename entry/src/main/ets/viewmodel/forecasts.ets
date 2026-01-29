import {casts} from "./casts"
export class forecasts{
  city:string
  adcode:number
  casts:Array<casts>

  constructor(city: string, adcode: number, casts: Array<casts>) {
    this.city = city;
    this.adcode = adcode;
    this.casts = casts;
  }
}
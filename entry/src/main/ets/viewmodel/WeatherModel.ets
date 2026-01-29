import { forecasts } from "./forecasts";

export class WeatherModel {
  status: number;
  count: number;
  infocode: number;
  forecasts: Array<forecasts> = [];

  constructor(status: number, count: number, infocode: number, forecasts: Array<forecasts> = []) {
    this.status = status;
    this.count = count;
    this.infocode = infocode;
    this.forecasts = forecasts;
  }
}
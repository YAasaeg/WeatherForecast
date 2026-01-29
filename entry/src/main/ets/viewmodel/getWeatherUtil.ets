// 引入WeatherModel和http模块
import { WeatherModel } from "../viewmodel/WeatherModel";
import { http } from '@kit.NetworkKit'

class getWeatherUtil {
  /**
   * 发送一个URL，返回对应的数据
   */
  getWeather(cityCode:number): Promise<WeatherModel> {
    return new Promise((resolve, reject) => {
      let request = http.createHttp();
      let url = `APIKEY&city=${cityCode}&extensions=all`;
      let result=request.request(url)
      result.then((res) => {
        if (res.responseCode === 200) {
          console.log('返回数据'+res.result.toString());
          resolve(JSON.parse(res.result.toString()))
        }
      }).catch((err:Error) => {
        console.log(err+"");
        reject(err);
      });
    });
  }

  async getWeathers(cityCodes:Array<number>){
    let promises:Array<Promise<WeatherModel>>=[]
    let weatherModels:Array<WeatherModel>=[]
    for(let i=0;i<cityCodes.length;i++){
      promises.push(this.getWeather(cityCodes[i]))
    }

    await Promise.all(promises).then(result=>{
      for(const element of result){
        console.log(element.forecasts[0].city)
      }
      weatherModels=result
    })
    return weatherModels
  }

}

let getweatherUtil=new getWeatherUtil()
export default getweatherUtil as getWeatherUtil
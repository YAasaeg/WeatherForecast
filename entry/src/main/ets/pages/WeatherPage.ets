import { router } from "@kit.ArkUI"
import { WeatherModel } from "../viewmodel/WeatherModel"
import getweatherUtil from "../viewmodel/getWeatherUtil"
import { cityView } from "../view/cityview"

@Entry
@Component
struct WeatherPage {
  @State cityWeatherList:Array<WeatherModel>=[]
  @State cityNameList:string[]=[]
  @State cityCodeList:number[]=[]
  @State cityindex:number=0
  weatherTabController:TabsController=new TabsController()

  onPageShow(){
    let params=router.getParams()
    if(Object(params)["codes"]) { this.cityCodeList = Object(params)["codes"] }
    if(Object(params)["names"]) { this.cityNameList = Object(params)["names"] }
    if(this.cityCodeList.length>0){ this.initDate() }
  }

  async initDate(){
    let result:Array<WeatherModel>=await getweatherUtil.getWeathers(this.cityCodeList)
    this.cityWeatherList=[]
    this.cityNameList=[]
    for(let i=0;i<result.length;i++){
      let ACityWeather =new WeatherModel(result[i].status,result[i].count,result[i].infocode,result[i].forecasts)
      this.cityWeatherList.push(ACityWeather)
      let cityName=result[i].forecasts[0].city
      this.cityNameList.push(cityName)
    }
  }

  build(){
    Column(){
      Row(){
        Button("添加").fontSize(25).fontColor(Color.Gray).opacity(0.7).backgroundColor("#87CEEB").margin({bottom: 15 }).onClick(()=>{
          router.push(({ url:"pages/AddCityWeatherPage", params:{ codes:this.cityCodeList, names:this.cityNameList } }))
        })
        Text(this.cityNameList[this.cityindex]).fontSize(40).fontColor(Color.Orange)
        Button("删除").fontSize(25).fontColor(Color.Gray).opacity(0.7).backgroundColor("#87CEEB").margin({bottom: 15 }).onClick(() => {
          AlertDialog.show({ title: '提示消息', message: `你确定要删除${this.cityNameList[this.cityindex]}吗`, autoCancel: true, alignment: DialogAlignment.Center, gridCount: 3, offset: { dx: 0, dy: 0 },
            primaryButton: { value: '确认', action: async () => {
              this.cityNameList = this.cityNameList.filter((item) => item !== this.cityNameList[this.cityindex])
              this.cityCodeList = this.cityCodeList.filter((item) => item !== this.cityCodeList[this.cityindex])
              this.cityWeatherList = this.cityWeatherList.filter((item) => item !== this.cityWeatherList[this.cityindex])
              AlertDialog.show({ message:"删除成功" }) }, fontColor: '#ff01a4d4' },
            secondaryButton: { value: '取消', action: () => {}, fontColor: '#ffb7b7b7' }, })
        })
      }.width('100%').height('10%').justifyContent(FlexAlign.SpaceBetween)

      Tabs({barPosition:BarPosition.Start,controller:this.weatherTabController}){
        ForEach(this.cityWeatherList,(cityWeather:WeatherModel)=>{
          TabContent(){ cityView({casts:cityWeather.forecasts[0].casts}) }
        })
      }.barWidth(50).barHeight(40).onChange((index:number)=>{ this.cityindex=index })
    }.width('100%').height('100%').backgroundColor("#99fff8c2")
  }
}


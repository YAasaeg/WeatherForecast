import  getweatherUtil from "../viewmodel/getWeatherUtil"
import { WeatherModel } from "../viewmodel/WeatherModel"
import {  router } from "@kit.ArkUI"
import { cityView } from "../view/cityview"
import { ensureTable, readAll, saveBulk, deleteCode } from "../data/WeatherStore"
import { relationalStore } from "@kit.ArkData"


@Entry
@Component
struct Index {
  //天气城市代码集合
  @State cityCodeList:number[]=[]
  //天气名字集合
  @State cityNameList:string[]=[]
  @State cityWeatherList:Array<WeatherModel>=[]
  @State FoodCity:string=""
  //当前城市索引
  @State cityindex:number=0
  weatherTabController:TabsController=new TabsController()
  Homecontroller: TabsController = new TabsController()
  //Home的Tab
  @State HomeTabBarcurrentIndex: number = 0

  //数据库初始化操作
  @State tableNameWeather:string = 'weatherlist'
  store: relationalStore.RdbStore | null = null
  sqlCreateWeather: string = `CREATE TABLE IF NOT EXISTS ${this.tableNameWeather} (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         CityCode INTEGER
      )`
  //天气自定义按钮样式
  @Builder tabBuild(index:number){
    Circle({width:10,height:10}).fill(this.cityindex === index ?Color.White:Color.Grey).opacity(0.4)
  }
  onPageShow(): void {
    //天气操作
    let params=router.getParams()
    if(Object(router.getParams())["codes"]!=null) {
      this.cityCodeList = Object(router.getParams())["codes"];
      console.log('Before initDate:', this.cityWeatherList, this.cityNameList);
      //清空数据
      this.cityWeatherList=[]
      this.cityNameList=[]
      this.saveWeatherList()
      this.initDate()
    }
  }
  async aboutToAppear(): Promise<void> {
    await ensureTable()
    const codes = await readAll()
    this.cityCodeList = []
    for (const c of codes) { this.cityCodeList.push(c) }
    this.initDate()
  }
  async initDate(){
    this.cityWeatherList = [];
    this.cityNameList = [];
    let result:Array<WeatherModel>=await getweatherUtil.getWeathers(this.cityCodeList)
    console.log('',result.length);
    for(let i=0;i<result.length;i++){
      let ACityWeather = new WeatherModel(result[i].status,result[i].count,result[i].infocode,result[i].forecasts);
      this.cityWeatherList.push(ACityWeather)
      let cityName=result[i].forecasts[0].city
      this.cityNameList.push(cityName)
    }
    console.log('After initDate:', this.cityWeatherList, this.cityNameList);
  }

  // 获取数据库管理对象
  async getStoreInstance() {
    // 如果已经存在，直接返回
    if (this.store) {
      return this.store
    }
    // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'weather9.db',
      securityLevel: relationalStore.SecurityLevel.S1,
    })
    this.store.executeSql(this.sqlCreateWeather)
    return this.store
  }

  async saveWeatherList() {
    await saveBulk(this.cityCodeList)
  }
  async deleteCityCodeFromDB(code:number) {
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableNameWeather);
    predicates.equalTo('CityCode', code);
    await store.delete(predicates);
  }

  build() {
    Column(){
          Column() {
            Row()
            {
              Button() {
                Image($r("app.media.add")).width(20).height(20)
              }
                .width(44)
                .height(44)
                .backgroundColor("#ffe9f4ff")
                .borderRadius(12)
                .onClick(()=>{
                  router.push(({
                    url:"pages/AddCityWeatherPage",
                    params:{
                      codes:this.cityCodeList,
                      names:this.cityNameList
                    }
                  }))
                })
                .margin({ left: 16 })

              Text(this.cityNameList[this.cityindex])
                .fontSize(28)
                .fontWeight(FontWeight.Medium)
                .fontColor("#222222")
                .margin({ left: 8 })

              Button() {
                Image($r("app.media.delete")).width(20).height(20)
              }
                .width(44)
                .height(44)
                .backgroundColor("#ffe9f4ff")
                .borderRadius(12)
                .onClick(() => {
                  AlertDialog.show({
                    title: '提示消息',
                    message: `你确定要删除${this.cityNameList[this.cityindex]}吗`,
                    autoCancel: true,
                    alignment: DialogAlignment.Center,
                    gridCount: 3,
                    offset: { dx: 0, dy: 0 },
                    primaryButton: {
                      value: '确认',
                      action: async () => {
                        const delCode:number = this.cityCodeList[this.cityindex];
                        this.cityNameList = this.cityNameList.filter((item) => item !== this.cityNameList[this.cityindex]);
                        this.cityCodeList = this.cityCodeList.filter((item) => item !== this.cityCodeList[this.cityindex]);
                        this.cityWeatherList = this.cityWeatherList.filter((item) => item !== this.cityWeatherList[this.cityindex]);
                        await deleteCode(delCode);
                        await this.initDate();
                        this.cityindex = Math.max(0, this.cityindex - 1);
                      },
                      fontColor: '#0f172a'
                    },
                    secondaryButton: {
                      value: '取消',
                      action: () => {},
                      fontColor: '#64748b'
                    },
                  })})
                .margin({ right: 16 })
            }
            .width('100%')
            .height(64)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({bottom:10})
            Tabs({barPosition:BarPosition.Start,controller:this.weatherTabController}){
              ForEach(this.cityWeatherList,(cityWeather:WeatherModel)=>{
                TabContent(){
                  Column() {
                    Column() {
                      cityView({casts: cityWeather.forecasts[0].casts})
                    }
                    .width('95%')
                    .backgroundColor("#ffe9f4ff")
                    .borderRadius(16)
                    .padding(14)
                    .height('95%')
                  }
                }.tabBar(this.tabBuild(this.cityWeatherList.findIndex(obj=>obj===cityWeather)))
                //findIndex寻找索引
              })
            }.backgroundColor("#ffe9f4ff").barWidth(50).barHeight(20).onChange((index:number)=>{
              this.cityindex=index
            })

          }
          .width('100%')
          .height('100%')
    }

  }
}

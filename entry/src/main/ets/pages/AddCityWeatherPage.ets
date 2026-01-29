import { router } from '@kit.ArkUI';
import { insertCode } from "../data/WeatherStore"

@Entry
@Component
struct AddCityWeatherPage {
  @State AllCityCodeList:Array<number>=[
    110000,120000,310000,500000,
    440100,440300,440400,440600,441900,441300,
    330100,330200,330300,330400,330600,330700,331000,
    320100,320200,320400,320500,321000,321100,
    510100,610100,420100,410100,340100,430100,360100,
    350100,350200,350300,350500,
    530100,520100,450100,
    460100,460200,
    130100,140100,150100,
    210100,210200,220100,230100,
    370100,370200,370600,410300
  ]
  @State AllCityNameList:Array<string>=[
    "北京市","天津市","上海市","重庆市",
    "广州市","深圳市","珠海市","佛山市","东莞市","惠州市",
    "杭州市","宁波市","温州市","嘉兴市","绍兴市","金华市","台州市",
    "南京市","无锡市","常州市","苏州市","扬州市","镇江市",
    "成都市","西安市","武汉市","郑州市","合肥市","长沙市","南昌市",
    "福州市","厦门市","莆田市","泉州市",
    "昆明市","贵阳市","南宁市",
    "海口市","三亚市",
    "石家庄市","太原市","呼和浩特市",
    "沈阳市","大连市","长春市","哈尔滨市",
    "济南市","青岛市","烟台市","洛阳市"
  ]
  //接收城市数字和城市姓名
  @State cityCodeList:number[]=[]
  @State cityNameList:string[]=[]
  @State searchValue:string=''
  @State fliterCityList:Array<string>=[]
  filterCities(value:string):void{
    this.fliterCityList=this.AllCityNameList.filter((name)=>name.includes(value))
  }
onPageShow(): void {
let params=router.getParams()
  this.cityCodeList=Object(router.getParams())["codes"];
this.cityNameList=Object(router.getParams())["names"];

}
  build() {
      Column() {
       Row(){
         Text("添加城市").fontSize(24).fontColor("#222222").margin({ left: 5 })
         Blank()
         Image($r("app.media.return")).width(30).height(30)
           .borderRadius(12)
           .onClick(()=>{
             router.back({
               url:'pages/Index',
               params:{
                 codes:this.cityCodeList,
                 names:this.cityNameList
               }
             })
           })
       }.height(64).width("95%")
        Column(){
         Search({ value: this.searchValue, placeholder: '请输入城市.....' })
           .searchButton('搜索')
           .cancelButton({ style: CancelButtonStyle.CONSTANT, icon: { src: $r('app.media.cancel') } })
           .width('95%')
           .height(44)
           .maxLength(20)
           .backgroundColor('#ffffff')
           .placeholderColor(Color.Grey)
           .placeholderFont({ size: 14, weight: 400 })
           .textFont({ size: 14, weight: 400 })
           .onChange((value: string) => { this.searchValue = value; this.filterCities(value); })
           .margin({ top: 8, bottom: 12 })
         List(){
           ForEach(this.searchValue===''?this.AllCityNameList:this.fliterCityList,(name:string)=>{
             ListItem(){
               if(this.cityNameList.includes(name)){
                 Column(){
                   Row(){
                     Text(name).fontSize(18).fontColor("#0f172a").margin({ left: 16 })
                     Blank()
                     Text("已添加").fontSize(14).fontColor("#64748b").opacity(0.9).margin({ right: 16 })
                   }.width("100%").height(48)
                 }
                 .width("95%")
                 .backgroundColor("#ffffff")
                 .borderRadius(12)
                 .padding(8)
                 .margin({ top: 10 })
               }
               else  {
                 Column(){
                   Row(){
                     Text(name).fontSize(18).fontColor("#0f172a").margin({ left: 16 })
                     Blank()
                     Button("添加")
                       .fontSize(14)
                       .fontColor("#ffffff")
                       .backgroundColor("#3a6ff8")
                       .borderRadius(10)
                       .width(64)
                       .height(32)
                       .margin({ right: 16 })
                       .onClick(async ()=>{
                         this.cityNameList.push(name)
                         let index=this.AllCityNameList.findIndex(obj=>obj===name)
                         let cityCode:number=this.AllCityCodeList[index]
                         if (!this.cityCodeList.includes(cityCode)) {
                           this.cityCodeList.push(cityCode)
                           await insertCode(cityCode)
                         }
                       })
                   }.width("100%").height(48)
                 }
                 .width("95%")
                 .backgroundColor("#ffffff")
                 .borderRadius(12)
                 .padding(8)
                 .margin({ top: 10 })
               }
             }
           })
         }
        }.width("100%").height("90%")
      }
      .width('100%')
    .height('100%')
      .backgroundColor("#F5F9FF")
  }
}

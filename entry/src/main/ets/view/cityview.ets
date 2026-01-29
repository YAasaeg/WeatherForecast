import { casts } from '../viewmodel/casts'
@Component
export struct cityView{
  //城市天气数据
  casts:Array<casts>=[]

  @Builder weatherImage(weather:string){
    if (weather.includes("晴")) {
      Image($r('app.media.sun')).width(30).objectFit(ImageFit.Fill).height(30)
    }
    if (weather.includes("阴") ){
      Image($r('app.media.gray')).width(30).objectFit(ImageFit.Fill).height(30)
    }
    if (weather.includes("多云")) {
      Image($r('app.media.fullcloud')).width(30).objectFit(ImageFit.Fill).height(30)
    }
    if (weather.includes("雨")&&weather!='雨夹雪') {
      Image($r('app.media.rainning')).width(30).objectFit(ImageFit.Fill).height(30)
    }
    if (weather.includes("雪")&&weather!='雨夹雪') {
      Image($r('app.media.xue')).width(30).objectFit(ImageFit.Fill).height(30)
    }
    if (weather=='雨夹雪') {
      Image($r('app.media.yjx')).width(30).objectFit(ImageFit.Fill).height(30)
    }
  }
  //展示数据
  build() {
    Column(){
      ForEach(this.casts,(cast:casts)=>{
        if(this.casts[0]===cast){
          Row(){
            if (cast.dayweather.includes("晴")) {
              Image($r('app.media.sun')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
            if (cast.dayweather.includes("阴")) {
              Image($r('app.media.gray')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
            if (cast.dayweather==="多云") {
              Image($r('app.media.fullcloud')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
            if (cast.dayweather.includes("雨")&&cast.dayweather!='雨夹雪') {
              Image($r('app.media.rainning')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
            if (cast.dayweather.includes("雪")&&cast.dayweather!='雨夹雪') {
              Image($r('app.media.xue')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
            if (cast.dayweather=='雨夹雪') {
              Image($r('app.media.yjx')).width(250).objectFit(ImageFit.Fill).height("90%")
            }
          }.height("25%")

Column(){
            Row(){
              Text(cast.dayweather)
                .fontSize(30)
                .fontWeight(FontWeight.Bold)

              Text(" "+cast.nighttemp+"° ~"+cast.daytemp+"°")
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
            }
  Row(){
    Text(cast.daywind+"风")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)

    Text(cast.daypower+"级")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
  }.margin({top:10})


  Row() {
    Text("出行穿衣：").fontSize(20).fontWeight(FontWeight.Bold).margin({left:10,right:5})
    if (cast.daytemp <5||cast.nighttemp<5) {
      Column()
      {
        Text("建议穿保暖衣物")
      Row() {
        Image($r("app.media.yrf")).height(40).width(40).objectFit(ImageFit.Fill)
        Image($r("app.media.wj")).height(40).width(40).objectFit(ImageFit.Fill).margin({left:7})
      }.justifyContent(FlexAlign.SpaceAround)
    }
    }

    else if (cast.daytemp>5||cast.nighttemp>5) {
      Column()
      {
        Text("天气较凉，请多添衣")
        Row() {
          Image($r("app.media.xxf")).height(40).width(40).objectFit(ImageFit.Fill)
          Image($r("app.media.qyqk")).height(40).width(40).objectFit(ImageFit.Fill).margin({left:7})
        }.justifyContent(FlexAlign.SpaceAround)
      }
    }
  }.height("10%").borderRadius(24).backgroundColor("#57b8b8b8").width("80%").opacity(0.9).margin({top:10,bottom:10})
}
        }
      })
//近期天气
      Column(){
        Text("近期天气一览").fontSize(26).margin({top:20,bottom:5})
        Row(){
          ForEach(this.casts,(cast:casts)=>{
            Column(){
             Text(cast.date.substring(5))
             this.weatherImage(cast.dayweather)
             Text(cast.daytemp.toString()+" °")
              Line().width(20).height(80).startPoint([10,0])
                .endPoint([10,70])
                .stroke(Color.Black)
                .strokeWidth(3)
                .strokeDashArray([10,3])

             Text(cast.nighttemp.toString()+" °")
              this.weatherImage(cast.nightweather)
            }
          })
        }.width("80%").height("75%").backgroundColor("#88c8c0ca").opacity(0.9).justifyContent(FlexAlign.SpaceAround).borderRadius(24)

      }.width("100%").height("45%")
    }.width("100%").height("100%")
  }
}
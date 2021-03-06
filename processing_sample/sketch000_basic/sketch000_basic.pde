ArrayList<Status> statuslog; //CSVのデータをまとめたStatusクラスの可変長配列

//各値の最大値、最小値用の変数
float ondoMax; 
float ondoMin;
float shitsudoMax;
float shitsudoMin;
float taikiMax;
float taikiMin;
float shodoMax;
float shodoMin;
float dojoMax;
float dojoMin;


void setup(){
  size(600,600);
  background(0);
  noStroke();
  fill(255);
  
  colorMode(HSB);
  
  //statuslogを初期化する
  statuslog = new ArrayList<Status>();
  
  //CSVを読み込んでstatuslogへ格納する
  String dataLines[];
  dataLines = loadStrings("sensor_edi.csv");

  //CSVから1行ずつ取り出して処理
  for(int i=0; i < dataLines.length; i++){

    //1行を「,」で分割してdata配列に格納
    String data[] = dataLines[i].split(",");
    
    //データに欠損がない場合のみstatuslogに追加
    if(data.length == 7){
      Status status = new Status(dataLines[i]);
      statuslog.add(status);
      
      //ここからさきは最大値、最小値を調べている
      if(i==0){
        ondoMax = ondoMin = status.ondo;
        shitsudoMax = shitsudoMin = status.shitsudo;
        taikiMax = taikiMin = status.taiki;
        shodoMax = shodoMin = status.shodo;
        dojoMax = dojoMin = status.dojo;
        
      }else{
        if(status.ondo > ondoMax) ondoMax = status.ondo;
        else if(status.ondo < ondoMin) ondoMin = status.ondo; 
        
        if(status.shitsudo > shitsudoMax) shitsudoMax = status.shitsudo;
        else if(status.shitsudo < shitsudoMin) shitsudoMin = status.shitsudo; 
        
        if(status.taiki > taikiMax) taikiMax = status.taiki;
        else if(status.taiki < taikiMin) taikiMin = status.taiki; 
        
        if(status.shodo > shodoMax) shodoMax = status.shodo;
        else if(status.shodo < shodoMin) shodoMin = status.shodo;
        
        if(status.dojo > dojoMax) dojoMax = status.dojo;
        else if(status.dojo < dojoMin) dojoMin = status.dojo;
      }
      
      
    }
    
  }
}


void draw(){
  background(0);
  //座標、円の大きさ、色相、アルファにデータを当てはめて描画してみる。
  for(int i=0; i<statuslog.size(); i++){
    float x = map(statuslog.get(i).ondo, ondoMin, ondoMax, 0, width);
    float y = map(statuslog.get(i).shitsudo, shitsudoMin, shitsudoMax, 0, height);
    float w = map(statuslog.get(i).taiki, taikiMin, taikiMax, 5,50);
    float hue = map(statuslog.get(i).shodo, shodoMin, shodoMax, 128,255);
    float alpha = map(statuslog.get(i).dojo, dojoMax, dojoMin, 10, 200);
    fill(hue,255,255,alpha);
    ellipse(x, y, w, w);
  }
  int dataNum = statuslog.size();
  String logStart = statuslog.get(0).time;
  String logEnd = statuslog.get(dataNum-1).time;
  
  fill(255);
  textSize(14);
  text("lifelog of the tree, data size: " + dataNum , 10, height - 40);
  text(logStart + " to " + logEnd , 10,  height - 20);
  
  
}
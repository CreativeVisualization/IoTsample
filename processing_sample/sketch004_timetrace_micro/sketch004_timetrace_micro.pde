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
long utimeMax;//utimeの最大値
long utimeMin;//utimeの最小値
float ctimeMax; //unixtimeを圧縮したもの
float ctimeMin;

//グリッドの両端を指定
String timeGridStart = "2017-04-19 17:29:00";
String timeGridEnd = "2017-04-19 19:55:00";
//long timeGridStep = 3600 * 1000; //24時間間隔とする（24時間*3600秒*1000ミリ秒）
long utimeGridStart = toUnixtime(timeGridStart);
long utimeGridEnd = toUnixtime(timeGridEnd);
float ctimeGridStep = 5 ;
float ctimeGridStart = compressUtime(utimeGridStart); //unix時間を圧縮してfloatに変換したもの
float ctimeGridEnd = compressUtime(utimeGridEnd);

//ビジュアライズするデータの時間の進行を管理する
Timekeeper tk;
boolean traceStart = false;

void setup(){
  size(1200,600);
  background(0);
  noStroke();
  fill(255);
  //noLoop();
  
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
        utimeMax = utimeMin = status.utime;
        
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
        
        if(status.utime > utimeMax) utimeMax = status.utime;  //時刻の最大値
        else if(status.utime < utimeMin) utimeMin = status.utime;  //時刻の最小値
      }
      
      
    }
    
  }
  
  //tkの初期化
  tk = new Timekeeper(ctimeGridStart, 0, 0.1, ctimeGridEnd);
  println("utimeGridStart" + utimeGridStart);
  println("utimeGridEnd" + utimeGridEnd);
}


void draw(){
  background(0);
  
  //時間のグリッドを引く
  
  stroke(0,0,200,128);
  strokeWeight(1);
  for(float i=ctimeGridStart; i<=ctimeGridEnd; i+=ctimeGridStep){
    float x = map(i , ctimeGridStart, ctimeGridEnd, 0, width);
    line(x, 0, x, height);
    fill(255,128);
    pushMatrix();
    translate(x, 20);
    rotate(PI/2);
    text(toTimeString( unCompressUtime(i)).substring(0,16), 0, 0);
    popMatrix();
    
  }
  noStroke();
  
  
  
  //左から右へ時系列で、円の大きさ、色相、アルファにデータを当てはめて描画してみる。
  
  for(int i=0; i<statuslog.size(); i++){
    float x = map(statuslog.get(i).ctime, ctimeGridStart, ctimeGridEnd, 0, width); //グリッドの最小値と最大値の間でmap
    float y = map(statuslog.get(i).shitsudo, shitsudoMin, shitsudoMax, height, 0); //上下を反転してmapする（最大値->0,最小値->heightにマップ)
    float w = map(statuslog.get(i).taiki, taikiMin, taikiMax, 1,20);
    float hue = map(statuslog.get(i).shodo, shodoMin, shodoMax, 128,255);
    float alpha = map(statuslog.get(i).dojo, dojoMax, dojoMin, 10, 200);
    fill(hue,255,255,alpha);
    ellipse(x, y, w, w);
  }

  
  //tkをアップデート
  if(traceStart){
    tk.update();
  }
  
  float nowx = map(tk.now , ctimeGridStart, ctimeGridEnd, 0, width);
  
  //tkの現在時刻がデータが持つ時間範囲のなかにあるか判定
  println(statuslog.get(0).ctime <= tk.now);
  if( statuslog.get(0).ctime <= tk.now){
    tk.inDataRange = true;
  }
  if( statuslog.get( statuslog.size() -1 ).ctime <= tk.now){
    tk.inDataRange = false;
    tk.index = 0;
  }
  
  //範囲内であれば
  if(tk.inDataRange){
    float ctime = statuslog.get(tk.index).ctime;
    float next_ctime = statuslog.get(tk.index+1).ctime;
    float shitsudo = statuslog.get(tk.index).shitsudo;
    float next_shitsudo = statuslog.get(tk.index+1).shitsudo;
  
    println(tk.index + "|" +statuslog.get(tk.index).utime);
  
    if( (tk.now - ctime) / (next_ctime - ctime) >=1.0 ){
      tk.index ++ ;
      if(tk.index == statuslog.size()-1){
        tk.index = 0;
      }
    }
  
    float lerpShitsudo = lerp(shitsudo, next_shitsudo,  (tk.now - ctime) / (next_ctime - ctime) ) ;
    fill(0,255,255);
    float shitsudo_y = map(lerpShitsudo, shitsudoMin, shitsudoMax, height, 0);
    ellipse(nowx, shitsudo_y, 10,10);
  }
  
  //現在時刻をラインで描画
  
  stroke(255,255,255);
  strokeWeight(1);
  line(nowx, 0, nowx, height);
  fill(255,255,255);
  String nowTime = toTimeString ( unCompressUtime(tk.now) );
  text(tk.inDataRange+" "+ nowTime, nowx, height-20);
  
  //湿度をドットで描画
  

  
}

//文字列の時刻（2017-05-09 16:36:35）をUnix時間（1970-01-01 00:00:00からの秒数）に変換
long toUnixtime(String _time){
    long uTime = 0;
    String HIZUKE = _time.split(" ")[0]; //2017-05-09
    String JIKOKU = _time.split(" ")[1]; //16:36:35
    int year   = int( HIZUKE.split("-")[0] ); //2017
    int month  = int( HIZUKE.split("-")[1] ); //5
    int day    = int( HIZUKE.split("-")[2] ); //9
    int hour   = int( JIKOKU.split(":")[0] ); //16
    int min    = int( JIKOKU.split(":")[1] ); //36
    int sec    = int( JIKOKU.split(":")[2] ); //35

    //println(_time+" "+year+"/"+month+"/"+day+ " "+hour+":"+min+":"+sec );
  
    Date d = new Date(year, month-1, day, hour, min, sec);
    //println(d);
    uTime = d.getTime(); //unix時間に変換
    //println(uTime); //1322917251

  return uTime;
}

float compressUtime(long _utime){
  
  float result = _utime - utimeGridStart;
  result /= 100000;
  return result;
}

long unCompressUtime(float _ctime){

  long result = (long)_ctime * 100000 + utimeGridStart;
  return result;
}

//Unix時間から時間の文字列へ変換
String toTimeString(long utime){
  Date d = new Date(utime);
  return d.toString();
  
}

void keyPressed(){
 traceStart = !traceStart;
}
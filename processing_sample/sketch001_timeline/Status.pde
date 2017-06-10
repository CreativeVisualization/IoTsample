import java.util.*; //unix時間の計算に必要

class Status{
  String time; //example 2017-05-09 16:36:35
  int utime;
  float ondo;
  float shitsudo;
  float taiki;
  float shodo;
  float dojo;
  String file;
  
  //Statusのコンストラクタ
  Status(String _str){
      //引数（1行分のデータ）から各値を取り出す。
      //「"」をreplace()で除去しつつ、Strignからfloatへ変換など。
      String data[] = _str.split(",");
      time = data[0].replace("\"","");
      ondo = float(data[1].replace("\"",""));
      shitsudo = float(data[2].replace("\"",""));
      taiki = float(data[3].replace("\"",""));
      shodo = float(data[4].replace("\"",""));
      dojo = float(data[5].replace("\"",""));
      file = data[6].replace("\"","");
      
      utime = toUnixtime(time);
  }
  
  //文字列の時刻（2017-05-09 16:36:35）をUnix時間（1970-01-01 00:00:00からの秒数）に変換
  int toUnixtime(String _time){
      int uTime = 0;
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
      uTime = (int)(d.getTime()/1000); //unix時間に変換
      println(uTime); //1322917251

    return uTime;
  }
}
class Status{
  String time;
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
  }
}
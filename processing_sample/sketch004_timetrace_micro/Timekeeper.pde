class Timekeeper{
  //時間はすべてctimeで管理
  float now;
  float start;
  float end;
  int index;
  float speed;
  boolean inDataRange;
  
  Timekeeper(float _n, int _i, float _s, float _e){
    now = _n;
    start = now;
    index = _i;
    speed = _s;
    end = _e;
    inDataRange = false;
  }
  
  void update(){
    now += speed;
    //println(now);
    if(now > end){
      now = start;
    }
  }
  
}
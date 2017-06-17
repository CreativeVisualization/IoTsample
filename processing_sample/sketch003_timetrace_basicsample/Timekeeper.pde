class Timekeeper{
  float now;
  float start;
  float end;
  int index;
  float speed;
  
  Timekeeper(float _n, int _i, float _s, float _e){
    now = _n;
    start = now;
    index = _i;
    speed = _s;
    end = _e;
  }
  
  void update(){
    now += speed;
    if(now > end){
      now = start;
    }
  }
  
}
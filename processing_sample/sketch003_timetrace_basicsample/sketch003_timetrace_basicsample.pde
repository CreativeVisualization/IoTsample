ArrayList<Status> statuslog;

Timekeeper tk;

boolean traceStart = false;


void setup(){
 size(800,600);
 
 statuslog = new ArrayList<Status>();
 
 statuslog.add(new Status(0, 0));
 statuslog.add(new Status(100, 10.0));
 statuslog.add(new Status(200, 90.0));
 statuslog.add(new Status(300, 120.0));
 statuslog.add(new Status(450, 200.0));
 statuslog.add(new Status(700, 400.0));
 statuslog.add(new Status(800, 490.0));
 
 tk = new Timekeeper(0, 0, 1, 800);
 
 fill(255);
 noStroke();
 rectMode(CENTER);
}


void draw(){
  background(0);
  
 noStroke();
 fill(255);
  for(int i=0; i<statuslog.size(); i++){
    float x = statuslog.get(i).utime;
    float h = statuslog.get(i).ondo;
    float w = 20;
    rect(x, (height-50 -h/2), w, h);
    
  }
  
  if(traceStart){
    tk.update();
  }

  float utime = statuslog.get(tk.index).utime;
  float next_utime = statuslog.get(tk.index+1).utime;
  float ondo = statuslog.get(tk.index).ondo;
  float next_ondo = statuslog.get(tk.index+1).ondo;
  
  println(tk.index + "|" +statuslog.get(tk.index).utime);
  
  if( (tk.now - utime) / (next_utime - utime) >=1.0 ){
    tk.index ++ ;
    if(tk.index == statuslog.size()-1){
      tk.index = 0;
    }

  }
  
  float lerpH = lerp(ondo, next_ondo,  (tk.now - utime) / (next_utime - utime) ) ;
  
  float w = 20;
  
  noStroke();
  fill(50,160,255, 180);
  rect(tk.now, (height-50 -lerpH/2), w, lerpH);
  
  
  stroke(255);
  line(tk.now, 0, tk.now, height);
  
  
}

void keyPressed(){
 traceStart = !traceStart; 
}

// these need to be outside all classes for some incomprehensible javascript reason!
// pixel dimnsions

class JumpMarker{
  final color startPopEnd[] = {#00FF00,
                               #0000FF,
                               #FF0000};
  
  void displayMark(int id){
    pushMatrix();
    pushStyle();
    fill (startPopEnd[id]);
    translate(-2*Defaults.trackWhiteWidth,Defaults.trackWhiteWidth);
    rect(0,0,2*Defaults.trackWhiteWidth,Defaults.trackBlackWidth);
    popStyle();
    popMatrix();
  }
  void displayMarkP(PGraphics pg,int id){
    pg.pushMatrix();
    pg.pushStyle();
    pg.fill (startPopEnd[id]);
    pg.translate(-2*Defaults.trackWhiteWidth,Defaults.trackWhiteWidth);
    pg.rect(0,0,2*Defaults.trackWhiteWidth,Defaults.trackBlackWidth);
    pg.popStyle();
    pg.popMatrix();
  }
  
  void display(){
    pushMatrix();
    translate(Defaults.Jumplength*0.45,0);
    for (int i=0;i<3;i++){
      displayMark(i);
      translate(Defaults.Jumplength,0);
    }
    popMatrix();
  }
  
  void displayP(PGraphics pg){
    pg.pushMatrix();
    pg.translate(Defaults.Jumplength*0.45,0);
    for (int i=0;i<3;i++){
      displayMarkP(pg,i);
      pg.translate(Defaults.Jumplength,0);
    }
    pg.popMatrix();
  }
    
}

abstract class TrackSection{  
  float // startPoint[] =  new float[2], always 0,0
        endPoint[] =  new float[2],
        endRotation;
  
  abstract void display();
  abstract void displayP(PGraphics pg);
  
  final float nextXInc(){
    return endPoint[0];
  }
  final float nextYInc(){
    return endPoint[1];
  }
  final float nextAlpha(){
    return endRotation;
  }
}

class StraightSection extends TrackSection{
  float xLen;
 
  StraightSection(float lenMM){
    xLen = lenMM * Defaults.mm2pix;
    endPoint[0] = xLen;
    endPoint[1] = 0;
    endRotation = 0;
  }
 
  void display(){
    pushStyle();
    fill(Defaults.black);
    rect(0,0,xLen,Defaults.totalWidth);
    fill(Defaults.white);
    rect(0,0,xLen,Defaults.trackWhiteWidth);
    rect(0,Defaults.totalWidth-Defaults.trackWhiteWidth,xLen,Defaults.trackWhiteWidth);
    popStyle();
  }
  void displayP(PGraphics pg){
    pg.pushStyle();
    pg.fill(Defaults.black);
    pg.rect(0,0,xLen,Defaults.totalWidth);
    pg.fill(Defaults.white);
    pg.rect(0,0,xLen,Defaults.trackWhiteWidth);
    pg.rect(0,Defaults.totalWidth-Defaults.trackWhiteWidth,xLen,Defaults.trackWhiteWidth);
    pg.popStyle();
  }
}

class CurvedSection extends TrackSection {
  final float  dia = Defaults.trackOuterDiameter,
               rad = dia/2.0;
  float start,
        stop;
  boolean right;
  
  CurvedSection(float star, float sto,  boolean rt){
    right = rt;
    start = star;
    stop  = sto;
    endPoint[0] = right ? (rad * cos(stop)) : (rad-Defaults.totalWidth) *cos(-stop); // + (right ? 0 : -Defaults.totalWidth);
    endPoint[1] = (right? rad - rad * sin(-stop): (-rad+Defaults.totalWidth)-(-rad+Defaults.totalWidth) * sin(-stop)) ;
    endRotation = right? stop-start : start-stop;
  }
  
  void display(){
    pushMatrix();
    pushStyle();
    noStroke();
    translate(0,rad);
    float d = dia;
    fill(Defaults.white);
    if (!right){
      translate(0,-(Defaults.trackOuterDiameter-Defaults.totalWidth));
      scale(1,-1);
    }
    arc(0,0,d,d,start,stop);
    fill(Defaults.black);
    d -= 2.0*Defaults.trackWhiteWidth;
    arc(0,0,d,d,start,stop);
    fill(Defaults.white);
    d -= 2.0*Defaults.trackBlackWidth;
    arc(0,0,d,d,start,stop);
    fill(Defaults.grey);
    d -= 2.0*Defaults.trackWhiteWidth;
    arc(0,0,d,d,start,stop);
    popStyle();
    popMatrix();
  }  
   void displayP(PGraphics pg){
    pg.pushMatrix();
    pg.pushStyle();
    pg.translate(0,rad);
    float d = dia;
    pg.fill(Defaults.white);
     if (!right){
      pg.translate(0,-(Defaults.trackOuterDiameter-Defaults.totalWidth));
      pg.scale(1,-1);
    }
    pg.arc(0,0,d,d,start,stop);
    pg.fill(Defaults.black);
    d -= 2*Defaults.trackWhiteWidth;
    pg.arc(0,0,d,d,start,stop);
    pg.fill(Defaults.white);
    d -= 2*Defaults.trackBlackWidth;
    pg.arc(0,0,d,d,start,stop);
    pg.fill(Defaults.grey);
    d -= 2*Defaults.trackWhiteWidth;
    pg.arc(0,0,d,d,start,stop);
    pg.popStyle();
    pg.popMatrix();
  }  
}

void doOvalTrack(float x, float y, float w){
  noStroke();
  TrackSection ts = new StraightSection(Defaults.trackStraightLengthMM);
  TrackSection arc180 = new CurvedSection(-HALF_PI,HALF_PI,true);
  //TrackSection arcR90 = new CurvedSection(-HALF_PI,0,true);
  JumpMarker jm = new JumpMarker();
 
  pushMatrix();
  pushStyle();
  noStroke();
  
  // move to starting point!
  translate(x-Defaults.trackStraightLength,
            y-w/2.0); 
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
 
  arc180.display();
  translate(arc180.nextXInc(),arc180.nextYInc());
  rotate(arc180.nextAlpha());
  
  ts.display();
  jm.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());

  arc180.display();
  popMatrix();
}

void  do_ImageOvalTrack(PGraphics pg,float x, float y, float w){
  pg.beginDraw();
  pg.background(Defaults.grey);

  TrackSection ts = new StraightSection(Defaults.trackStraightLengthMM);
  TrackSection arc180 = new CurvedSection(-HALF_PI,HALF_PI,true);
  //TrackSection arcR90 = new CurvedSection(-HALF_PI,0,true);
  
  JumpMarker jm = new JumpMarker();

  pg.pushMatrix();
  pg.pushStyle();
  pg.noStroke();
  
  // move to starting point!
  pg.translate(x-Defaults.trackStraightLength,
               y-w/2.0); 
  
  ts.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  arc180.displayP(pg);
  pg.translate(arc180.nextXInc(),arc180.nextYInc());
  pg.rotate(arc180.nextAlpha());
  
  ts.displayP(pg);
  jm.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  arc180.displayP(pg);
 
  pg.popStyle();
  pg.popMatrix();
  pg.endDraw();
}

void doCurvyTrack(float x, float y, float w){
  TrackSection ts = new StraightSection(Defaults.trackOuterDiameterMM-Defaults.totalWidth/Defaults.mm2pix);
  //TrackSection tsHalf = new StraightSection(0.5*Defaults.trackOuterDiameterMM-Defaults.totalWidth/Defaults.mm2pix);
  TrackSection arcR180 = new CurvedSection(-HALF_PI,HALF_PI,true);
  TrackSection arcL180 = new CurvedSection(-HALF_PI,HALF_PI,false);
  TrackSection arcR90 = new CurvedSection(-HALF_PI,0,true);
  //TrackSection arcR45 = new CurvedSection(-HALF_PI,-HALF_PI/2.0,true);
  //TrackSection arcL45 = new CurvedSection(-HALF_PI,-HALF_PI/2.0,false);
  //TrackSection arcL90 = new CurvedSection(-HALF_PI,0,false);
  
  JumpMarker jm = new JumpMarker();
  
  final float epsilon = 0.5;
  
  pushMatrix();
  pushStyle();
  noStroke();
  
  // move to starting point!
  //translate(x,y);
  translate(x-Defaults.trackStraightLength,
            y-w/2.0); 
  
  arcR90.display();
  translate(arcR90.nextXInc(),arcR90.nextYInc());
  rotate(arcR90.nextAlpha());
  
  arcL180.display();
  translate(arcL180.nextXInc(),arcL180.nextYInc());
  rotate(arcL180.nextAlpha());
  
  arcR180.display();
  translate(arcR180.nextXInc(),arcR180.nextYInc());
  rotate(arcR180.nextAlpha());
  
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  
  arcR90.display();
  translate(arcR90.nextXInc(),arcR90.nextYInc()-epsilon);
  rotate(arcR90.nextAlpha());

  ts.display();
  jm.display();
  translate(ts.nextXInc()-epsilon,ts.nextYInc());
  rotate(ts.nextAlpha());
  
  ts.display();
  translate(ts.nextXInc()-epsilon,ts.nextYInc());
  rotate(ts.nextAlpha());
  
  arcR90.display();
  translate(arcR90.nextXInc(),arcR90.nextYInc());
  rotate(arcR90.nextAlpha());
  
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arcR90.display();
  translate(arcR90.nextXInc(),arcR90.nextYInc());
  rotate(arcR90.nextAlpha());
  
  popStyle();
  popMatrix();
}

void  doImageCurvyTrack(PGraphics pg,float x, float y, float w){
  pg.beginDraw();
  pg.background(Defaults.grey);
  
  TrackSection ts = new StraightSection(Defaults.trackOuterDiameterMM-Defaults.totalWidth/Defaults.mm2pix);
  //TrackSection tsHalf = new StraightSection(0.5*Defaults.trackOuterDiameterMM-Defaults.totalWidth/Defaults.mm2pix);
  TrackSection arcR180 = new CurvedSection(-HALF_PI,HALF_PI,true);
  TrackSection arcL180 = new CurvedSection(-HALF_PI,HALF_PI,false);
  TrackSection arcR90 = new CurvedSection(-HALF_PI,0,true);
  //TrackSection arcR45 = new CurvedSection(-HALF_PI,-HALF_PI/2.0,true);
  //TrackSection arcL45 = new CurvedSection(-HALF_PI,-HALF_PI/2.0,false);
  //TrackSection arcL90 = new CurvedSection(-HALF_PI,0,false);
  
  JumpMarker jm = new JumpMarker();
  
  final float epsilon = 0.5;
  
  pg.pushMatrix();
  pg.pushStyle();
  pg.noStroke();
  
  // move to starting point!
  pg.translate(x-Defaults.trackStraightLength,
            y-w/2.0); 
  
  arcR90.displayP(pg);
  pg.translate(arcR90.nextXInc(),arcR90.nextYInc());
  pg.rotate(arcR90.nextAlpha());
  
  arcL180.displayP(pg);
  pg.translate(arcL180.nextXInc(),arcL180.nextYInc());
  pg.rotate(arcL180.nextAlpha());
  
  arcR180.displayP(pg);
  pg.translate(arcR180.nextXInc(),arcR180.nextYInc());
  pg.rotate(arcR180.nextAlpha());
  
  ts.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  arcR90.displayP(pg);
  pg.translate(arcR90.nextXInc(),arcR90.nextYInc()-epsilon);
  pg.rotate(arcR90.nextAlpha());

  ts.displayP(pg);
  jm.displayP(pg);
  pg.translate(ts.nextXInc()-epsilon,ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  ts.displayP(pg);
  pg.translate(ts.nextXInc()-epsilon,ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  arcR90.displayP(pg);
  pg.translate(arcR90.nextXInc(),arcR90.nextYInc());
  pg.rotate(arcR90.nextAlpha());
  
  ts.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  
  arcR90.displayP(pg);
  pg.translate(arcR90.nextXInc(),arcR90.nextYInc());
  pg.rotate(arcR90.nextAlpha());
  
  pg.popStyle();
  pg.popMatrix();
  pg.endDraw();
}
  
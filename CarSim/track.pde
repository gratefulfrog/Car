
// these need to be outside all classes for some incomprehensible javascript reason!
// pixel dimnsions
final float whiteWidth = Defaults.trackWhiteWidth,
            totalWidth = whiteWidth * 2 + Defaults.trackBlackWidth,
            Defaults_trackOuterDiameter = Defaults.trackOuterDiameter;
  

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

/* for track, we translate and rotate before disply, so th the track is 
 * always laid relative to zero
 */


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
    rect(0,0,xLen,totalWidth);
    fill(Defaults.white);
    rect(0,0,xLen,whiteWidth);
    rect(0,totalWidth-whiteWidth,xLen,whiteWidth);
    popStyle();
  }
  void displayP(PGraphics pg){
    pg.pushStyle();
    pg.fill(Defaults.black);
    pg.rect(0,0,xLen,totalWidth);
    pg.fill(Defaults.white);
    pg.rect(0,0,xLen,whiteWidth);
    pg.rect(0,totalWidth-whiteWidth,xLen,whiteWidth);
    pg.popStyle();
  }
}

class CurvedSection extends TrackSection {
  // only works for clockwise curves!
  final float  dia = Defaults_trackOuterDiameter,
               rad = dia/2;
  float start,
        stop;
  
  CurvedSection(float star, float sto){
    start = star;
    stop  = sto;
    endPoint[0] = rad * cos(stop);
    endPoint[1] = rad+rad * sin(stop);
    endRotation = stop-start;
  }
  
  void display(){
    pushMatrix();
    pushStyle();
    translate(0,rad);
    float d = dia;
    fill(Defaults.white);
    arc(0,0,d,d,start,stop);
    fill(Defaults.black);
    d -= 2*Defaults.trackWhiteWidth;
    arc(0,0,d,d,start,stop);
    fill(Defaults.white);
    d -= 2*Defaults.trackBlackWidth;
    arc(0,0,d,d,start,stop);
    fill(Defaults.grey);
    d -= 2*Defaults.trackWhiteWidth;
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

void doTrack(){
  noStroke();
  TrackSection ts = new StraightSection(Defaults.trackStraightLengthMM);
  TrackSection arc180 = new CurvedSection(-HALF_PI,HALF_PI);
  TrackSection arcR90 = new CurvedSection(-HALF_PI,0);
  // not ready! TrackSection arcL90 = new CurvedSection(0,-HALF_PI);
  pushMatrix();
  // move to starting point!
  translate(g_x-Defaults.trackStraightLength,
            g_y-g_w/2.0); 
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arc180.display();
  translate(arc180.nextXInc(),arc180.nextYInc());
  rotate(arc180.nextAlpha());
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arc180.display();
  popMatrix();
}

void  do_ImageTrack(PGraphics pg){
  pg.beginDraw();
  pg.background(Defaults.grey);
  pg.noStroke();
  TrackSection ts = new StraightSection(Defaults.trackStraightLengthMM);
  TrackSection arc180 = new CurvedSection(-HALF_PI,HALF_PI);
  TrackSection arcR90 = new CurvedSection(-HALF_PI,0);
  // not ready! TrackSection arcL90 = new CurvedSection(0,-HALF_PI);
  pg.pushMatrix();
  // move to starting point!
  pg.translate(g_x-Defaults.trackStraightLength,
               g_y-g_w/2.0); 
  ts.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  arc180.displayP(pg);
  pg.translate(arc180.nextXInc(),arc180.nextYInc());
  pg.rotate(arc180.nextAlpha());
  ts.displayP(pg);
  pg.translate(ts.nextXInc(),ts.nextYInc());
  pg.rotate(ts.nextAlpha());
  arc180.displayP(pg);
  pg.popMatrix();
  pg.endDraw();
}

/*
void doTrack(){
  noStroke();
  TrackSection ts = new StraightSection(Defaults.trackStraightLength);
  TrackSection arc180 = new CurvedSection(-HALF_PI,HALF_PI);
  TrackSection arcR90 = new CurvedSection(-HALF_PI,0);
  TrackSection arcL90 = new CurvedSection(0,HALF_PI);
  pushMatrix();
  // move to starting point!
  translate(g_x-Defaults.trackStraightLength,
            g_y-g_w/2.0); 
  //arcR90.display();
  translate(arcR90.nextXInc(),arcR90.nextYInc());
  rotate(arcR90.nextAlpha());
  //rotate(arcR90.nextAlpha());
  //print(degrees(arcR90.nextAlpha()));
  arc(0,0,100,100,0,-HALF_PI); 
  stroke(0);
  line(0,0,500,0);
  //arcL90.display();
  //exit();
  translate(arc.nextXInc(),arc.nextYInc());
  rotate(arc.nextAlpha());
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arc.display();
  popMatrix();
}
*/
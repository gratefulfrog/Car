abstract class TrackSection{
  final float whiteWidth = Defaults.trackWhiteWidth,
              totalWidth = Defaults.trackWhiteWidth * 2 + Defaults.trackBlackWidth;
  
  float // startPoint[] =  new float[2], always 0,0
        endPoint[] =  new float[2],
        endRotation;
  
  abstract void display();
  
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
 
  StraightSection(float len){
    xLen = len;
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
}
 
class CurvedSection extends TrackSection {
  static final float  dia = Defaults.trackOuterDiameter,
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
}


 void doTrack(){
  noStroke();
  TrackSection ts = new StraightSection(Defaults.trackStraightLength);
  TrackSection arc = new CurvedSection(-HALF_PI,HALF_PI);
  pushMatrix();
  // move to starting point!
  translate(g_x-Defaults.trackStraightLength,
            g_y-g_w/2.0); 
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arc.display();
  translate(arc.nextXInc(),arc.nextYInc());
  rotate(arc.nextAlpha());
  ts.display();
  translate(ts.nextXInc(),ts.nextYInc());
  rotate(ts.nextAlpha());
  arc.display();
  popMatrix();
 }
  
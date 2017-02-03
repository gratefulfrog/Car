/* TrackSim
 * Autonomous Car Simulation and DEvt. platform
 */


final boolean ISJS = false;

final int nbSections = 3;

TrackSection sections[] = new TrackSection[nbSections];

final float vInc = 1,
            sInc =radians(2);

void setup(){
  size(1800,900);
}
void doTrack(){
  background(Defaults.grey);
  noStroke();
  float x = width/2.0,
        y = height/2.0,
        w = Defaults.trackOuterDiameter;
  TrackSection ts = new StraightTrack(x-Defaults.trackStraightLength,y-w/2.,radians(0));
  ts.display();
  doArc(x,y,-HALF_PI,HALF_PI);
  TrackSection ts1 = new StraightTrack(x,y+Defaults.trackOuterDiameter/2.0,PI);
  ts1.display();
  doArc(x-Defaults.trackStraightLength,y,HALF_PI,HALF_PI+PI);
}
void doArc(float x, float y, float start, float stop){
  float  w = Defaults.trackOuterDiameter,
         h = Defaults.trackOuterDiameter;
  fill(Defaults.white);
  arc(x,y,w,h,start,stop,PIE);
  fill(Defaults.black);
  w -= 2*Defaults.trackWhiteWidth;
  h -= 2*Defaults.trackWhiteWidth;
  arc(x,y,w,h,start,stop,PIE);
  fill(Defaults.white);
  w -= 2*Defaults.trackBlackWidth;
  h -= 2*Defaults.trackBlackWidth;
  arc(x,y,w,h,start,stop,PIE);
  fill(Defaults.grey);
  w -= 2*Defaults.trackWhiteWidth;
  h -= 2*Defaults.trackWhiteWidth;
  arc(x,y,w,h,start,stop,PIE);
}


void draw(){
  doTrack();
}
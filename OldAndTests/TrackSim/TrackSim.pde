/* TrackSim
 * Autonomous Car Simulation and DEvt. platform
 */

float x,y,w;

PGraphics trackP;

boolean withImage =false;

void setup(){
  size(1800,900);
  x = width/4.0;
  y = height/8.0;
  w = Defaults.trackOuterDiameter;
  if (withImage){
    trackP = createGraphics(1800,900);
    doImageCurvyTrack(trackP,x,y,w);
    image(trackP,0,0);
  }
  else{
    background(Defaults.grey);
    doCurvyTrack(x,y,w);
  }
}
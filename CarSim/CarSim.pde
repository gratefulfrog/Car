/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */



final boolean ISJS = true;

Car car;

final float vInc = 1,
            sInc =radians(2);
float   x,
        y,
        w;
        
void setup(){
  size(1800,900);
   x = width/2.0 + Defaults.trackStraightLength/2.0;
   y = height/2.0;
   w = Defaults.trackOuterDiameter;
  reset();
}

void reset(){  
  car = new Car(x-Defaults.trackStraightLength,y-w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90));
}

void draw(){
  doTrack();
  car.display();
  car.displayParams();
  car.update(1);
}

void doTrack(){
  background(Defaults.grey);
  noStroke();
  TrackSection ts = new StraightTrack(x-Defaults.trackStraightLength,y-w/2.0,radians(0));
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

//////  key controls /////////


void keyPressed(){
  if (key == CODED){
    codedKey();
  }
  else{
    unCodedKey();
  }
}

void unCodedKey(){
  switch(key){
    case 'p':
    case 'P':
      car.velocitySet(0);
    case 's':
    case 'S':
      car.steeringAngleSet(0);
      break;
    case 'r':
    case 'R':
      reset();
      break;
    default:
      if (!ISJS){
        exit();
      }
      break;
  }
}

void codedKey(){
  switch(keyCode){
    case UP:
      car.velocityInc(vInc);
      break;
    case DOWN:
      car.velocityInc(-vInc);
      break;
    case LEFT:
      car.steeringAngleInc(-sInc);
      break;
    case RIGHT:
      car.steeringAngleInc(sInc);
      break;
  }
}
/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */



final boolean ISJS = true;

Car g_car;

final float g_vInc = 1,
            g_sInc =radians(5);
float   g_x,
        g_y,
        g_w;
        
void setup(){
  size(1800,900);
   g_x = width/2.0 + Defaults.trackStraightLength/2.0;
   g_y = height/2.0;
   g_w = Defaults.trackOuterDiameter;
  reset();
}

void reset(){  
  g_car = new Car(g_x-Defaults.trackStraightLength,g_y-g_w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90));
}

void draw(){
  background(Defaults.grey);
  doTrack();
  g_car.display();
  g_car.displayParams();
  g_car.update(1);
}

void doTrack(){
  noStroke();
  TrackSection ts = new StraightTrack(g_x-Defaults.trackStraightLength,g_y-g_w/2.0,radians(0));
  ts.display();
  doArc(g_x,g_y,-HALF_PI,HALF_PI);
  TrackSection ts1 = new StraightTrack(g_x,g_y+Defaults.trackOuterDiameter/2.0,PI);
  ts1.display();
  doArc(g_x-Defaults.trackStraightLength,g_y,HALF_PI,HALF_PI+PI);
}

void doArc(float x, float y, float start, float stop){
  float  w = Defaults.trackOuterDiameter,
         h = Defaults.trackOuterDiameter;
  fill(Defaults.white);
  //arc(x,y,w1,h1,start,stop,PIE);
  arc(x,y,w,h,start,stop);
  fill(Defaults.black);
  w -= 2*Defaults.trackWhiteWidth;
  h -= 2*Defaults.trackWhiteWidth;
  //arc(x,y,w,h,start,stop,PIE);
  arc(x,y,w,h,start,stop);
  fill(Defaults.white);
  w -= 2*Defaults.trackBlackWidth;
  h -= 2*Defaults.trackBlackWidth;
  //arc(x,y,w,h,start,stop,PIE);
  arc(x,y,w,h,start,stop);
  fill(Defaults.grey);
  w -= 2*Defaults.trackWhiteWidth;
  h -= 2*Defaults.trackWhiteWidth;
  //arc(x,y,w,h,start,stop,PIE);
  arc(x,y,w,h,start,stop);
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
      g_car.velocitySet(0);
    case 's':
    case 'S':
      g_car.steeringAngleSet(0);
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
      g_car.velocityInc(g_vInc);
      break;
    case DOWN:
      g_car.velocityInc(-g_vInc);
      break;
    case LEFT:
      g_car.steeringAngleInc(-g_sInc);
      break;
    case RIGHT:
      g_car.steeringAngleInc(g_sInc);
      break;
  }
}

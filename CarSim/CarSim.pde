/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */



final boolean ISJS = true;

Car g_car;

final float g_vInc = 1;

float g_maxS = Defaults.maxSteeringSensitivity,
      g_sInc = radians(g_maxS);

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
    case 'x':
    case 'X':
      g_sInc-= radians(1.0);
      break;
    case 'c':
    case 'C':
      g_sInc+=radians(1.0);
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

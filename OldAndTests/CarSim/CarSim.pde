/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */

final boolean ISJS = true;

Car g_car;
PGraphics g_track;

final float g_vInc = 1;

float g_maxS = Defaults.maxSteeringSensitivity,
      g_sInc = radians(Defaults.stdSteeringSensitivity),
      g_saInc = radians(g_maxS*0.01);
      
boolean g_steerAngle = true;


float   g_x,
        g_y,
        g_w;
        
void setup(){
  size(1800,900);
  g_x = width/2.0 + Defaults.trackStraightLength/2.0;
  g_y = height/2.0;
  g_w = Defaults.trackOuterDiameter;
  g_track = createGraphics(1800,900);
  do_ImageTrack(g_track);
  reset();
}

void reset(){  
  g_car = new Car(g_x-Defaults.trackStraightLength,g_y-g_w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90));
 
}

void draw(){
  background(Defaults.grey);
  doTrack();
  // too slow in firfox!
  //image(g_track,0,0);
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
      g_car.steeringAngularVelocitySet(0);
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
    case 'a':
    case 'A':
      g_steerAngle = !g_steerAngle;
      g_car.steeringAngularVelocitySet(0);
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
      if(g_steerAngle){
        g_car.steeringAngleInc(-g_sInc);
      }
      else{
        g_car.steeringAngularVelocityInc(-g_saInc);
      }
      break;
    case RIGHT:
      if(g_steerAngle){
        g_car.steeringAngleInc(g_sInc);
      }
      else{
        g_car.steeringAngularVelocityInc(g_saInc);
      }break;
  }
}
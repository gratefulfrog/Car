  /* CarSimM
 * Autonomous Car Simulation and DEvt. platform
 * this verison implements various experiments in modal control, doesn't really work yet 2017 02 09...
 */

final boolean ISJS   = true;

boolean  CURVY_TRACK = true;

defaults Defaults;
App app;
        
void setup(){
  size(1800,900);
  frameRate(50);  // nb steps per second
  Defaults = new defaults();
  app = new App();
}

void draw(){
  app.display();
}


void mousePressed(){
  CURVY_TRACK = ! CURVY_TRACK;
  Defaults  = new defaults();
  app = new App();
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
    case 'c':
    case 'C':
      app.sInc+=radians(1.0);
      break;
    case 'm':
    case 'M':
      app.manualSteering = !app.manualSteering;
      break;
    case 'p':
    case 'P':
      app.car.velocitySet(0);
      break;
    case 'r':
    case 'R':
      app.reset();
      break;
    case 's':
    case 'S':
      app.car.steeringAngleSet(0);
      app.car.steeringAngularVelocitySet(0);
      break;
    case 'x':
    case 'X':
      app.sInc-= radians(1.0);
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
      app.car.velocityInc(app.vInc);
      break;
    case DOWN:
      app.car.velocityInc(-app.vInc);
      break;
    case LEFT:
        app.car.steeringAngleInc(-app.sInc);
      break;
    case RIGHT:
      app.car.steeringAngleInc(app.sInc);
      break;
  }
}
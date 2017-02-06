/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */

final boolean ISJS        = true;

boolean       CURVY_TRACK = true;

defaults Defaults;
App app;
        
void setup(){
  size(1800,900);
  frameRate(50);  // nb steps per second
  Defaults = new defaults();
  app = new App(null);
}

//  loop variables
long count = 0;

void draw(){
  app.display(count++);
}


void mousePressed(){
  if (mouseX<Defaults.buttonsXLimit && mouseY<Defaults.buttonsYLimit){
    return;
  }
  CURVY_TRACK = ! CURVY_TRACK;
  Defaults  = new defaults();
  app = new App(app.pidDefaults);
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
    case 'a':
    case 'A':
      app.steerAngle = !app.steerAngle;
      app.car.steeringAngularVelocitySet(0);
      break;
    case 'c':
    case 'C':
      app.sInc+=radians(1.0);
      break;
    case 'd':
    case 'D':
      app.setPidDefaults();
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
      if(app.steerAngle){
        app.car.steeringAngleInc(-app.sInc);
      }
      else{
        app.car.steeringAngularVelocityInc(-app.saInc);
      }
      break;
    case RIGHT:
      if(app.steerAngle){
        app.car.steeringAngleInc(app.sInc);
      }
      else{
        app.car.steeringAngularVelocityInc(app.saInc);
      }break;
  }
}
/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */

final boolean ISJS = false;

App app;
        
void setup(){
  size(1800,900);
  //frameRate(15);  // nb steps per second
  app = new App();
}

//  loop variables
long count = 0;

void draw(){
  app.display(count++);
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
      app.setDefaults();
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
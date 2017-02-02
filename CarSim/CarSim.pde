/* CarSim
 * Autonomous Car Simulation and DEvt. platform
 */



final boolean ISJS = true;

Car car;

final float vInc = 1,
            sInc =radians(2);

void setup(){
  size(1800,900);
  background(0);
  reset();
}

void reset(){
  car = new Car(width/2.0,height/2.0,radians(0));
  car.display();
}

void draw(){
  background(0);
  car.display();
  car.displayParams();
  car.update(1);
}

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
   
abstract class SteeringMode{
  
  SteeringController controller;
  abstract float update(float mv, float dt);
  abstract float getError(Car car);
}

class PidSteeringMode extends SteeringMode{
  PID controller;
  
  PidSteeringMode(float setPoint,float KP,float KI,float KD){
    controller = new PID(setPoint, KP, KI, KD);
  }
  float getError(Car car){
    return -car.steeringError;
  }
  
  float update(float mv, float dt){
    return controller.update(mv,dt);
  }
}

abstract class SteeringController{
  abstract float update(float  error, float dt);
  abstract void display();
}
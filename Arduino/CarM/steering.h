#ifndef STEERING_H
#define STEERING_H

class SteeringMode{
  protected:         
      SteeringController &controller;
  public:
    virtual float update(float mv, float dt) =0;
    virtual float getError(Car car) =0;
};

class ManualSteeringMode public: SteeringMode{
  protected:
  public:
    ManualSteeringMode(byte id, float setPoint);
    float getError(const Car &car) const;
    float update(float mv, float dt);
};

class PidSteeringMode public: SteeringMode{
  protected:
    static float kp[],
           float ki[],
           float kd[];
    PID * controller;
    byte modeID;
  public:
    PidSteeringMode(byte id, float setPoint);
    float getError(const Car &car) const;
    float update(float mv, float dt);
};

abstract class SteeringController{
  abstract float update(float  error, float dt);
  abstract void display();
}

#endif


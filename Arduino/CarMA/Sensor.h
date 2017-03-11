#ifndef SENSOR_H
#define SENSOR_H

#include <Arduino.h>

class Sensor{
  protected:
    float val = 0;
  public:
    virtual void update(unsigned long dt) = 0;
    virtual float getValue() const {return val;};
};

class DistanceSensor: public Sensor{
  protected:
  public:
    virtual void update(unsigned long dt){return;}
};

class JumpSensor: public Sensor{
  protected:
  public:
    virtual void update(unsigned long dt){return;}
};

#endif

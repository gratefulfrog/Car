#ifndef BOBSERVO_H
#define BOBSERVO_H

#include <Arduino.h>
#include <Servo.h>
#include "ServoSpec.h"
#include "DebugDefs.h"

class BobServo{
  protected:
    const ServoSpec &spec;
    Servo servo;

    float currentAngle,            // degrees
          currentAngularVelocity;  // degrees/sec

    void goLim(int dir); // -1 == Counter Clockwise; 1 == Clockwise
    
  public:
    BobServo(int pin, const ServoSpec &spec);
    setAngle(float angle);                        // degrees
    setAngularVelocity(float angularVelocity);    // degrees/milli sec
    void update(float dt);                        // update angle % dt in milli seconds
    void update(float angularVelocity,float dt);  // set velocity before updating angle
    void sweep(int nbLoops);
    void center();
    void goCLimit();                                // set to clockwise endpoint
    void goCCLim();                                 // set to counter clockwise endpoint
    float getCurrentAngle() const;
    float getCurrentAngularVelocity() const;
    const ServoSpec& getSpec() const;
};

extern float reduceAngleDegrees(float angleDegrees);

#endif

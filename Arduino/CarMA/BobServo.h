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

    float microSecAccumulator = 0;

    void goLim(int dir); // -1 == Counter Clockwise; 1 == Clockwise
    
  public:
    BobServo(int pin, const ServoSpec &spec);
    setAngleD(float angle);                        // degrees
    setAngleR(float angle);                        // radians
    setAngularVelocityD(float angularVelocity);    // degrees/milli sec
    setAngularVelocityR(float angularVelocity);    // radians/milli sec
    void update(float dt);                        // update angle % dt in milli seconds
    void updateMicros(float dtMicros);            // update angle % dt in MICRO seconds using accumulator
    void updateD(float angularVelocity,float dt);  // set angular velocity in DEGREES before updating angle
    void updateR(float angularVelocity,float dt);  // set angular velocity in RADIANS before updating angle
    void sweep(int nbLoops);
    void center();
    void goCLim();                                // set to clockwise endpoint
    void goCCLim();                                 // set to counter clockwise endpoint
    float getCurrentAngleD() const;
    float getCurrentAngleR() const;
    float getCurrentAngularVelocityD() const;
    float getCurrentAngularVelocityR() const;
    const ServoSpec& getSpec() const;
};

extern float reduceAngleDegrees(float angleDegrees);

#endif

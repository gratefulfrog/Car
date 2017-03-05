#ifndef CAR_H
#define CAR_H

#include "BobServo.h"
#include "Sensor.h"
#include "Defaults.h"

class Car{
  protected:
    BobServo *bs;
    
    Sensor *sensorVec[];
  
    Sensor& frontSensor() const { return *sensorVec[0];}
    Sensor& rearSensor() const { return *sensorVec[1];}
    Sensor& jumpSensor() const { return *sensorVec[2];}

    // kinematics params
    float velocity = 0,
          steeringAngle =0,
          steeringAngularVelocity = 0;

    // navigation params
    float distanceFrontToWhite,
          headingDifferenceWithTrack;
  
    boolean inMiddle = false;
        
    // jump params    
    int jumpStatus = -1;
    
    float intoJumpVelocity,
          jumpInitX,
          jumpInitY;
    boolean jumping = false;
    void updateSteeringAndVelocity();
  
  public:
    Car ();
    // need to add dt to these and fix servo setting to icnorporate delay and maybe use the micro accumulator update??
    void steeringAngleSet(float a);
    void steeringAngleInc(float inc);
    void steeringAngularVelocitySet(float a);
    void steeringAngularVelocityInc(float inc);
    void velocitySet(float a);
    void velocityInc(float inc);
    void  update(unsigned long dt);  // milliseconds
    void updateSelfDrive(unsigned long dt);
};

#endif

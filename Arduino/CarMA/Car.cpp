#include "Car.h"

Car::Car (){
  bs = new BobServo(Defaults::servoPin, savoxSpec);
  sensorVec[0] =  new DistanceSensor();
  sensorVec[1] =  new DistanceSensor();
  sensorVec[2] =  new JumpSensor();
}

void Car::steeringAngleSet(float a){
  steeringAngle = max(-Defaults::maxSteeringAngle,min(a,Defaults::maxSteeringAngle));
  bs->setAngle(steeringAngle);
}
void Car::steeringAngleInc(float inc){
  steeringAngleSet(inc+steeringAngle);
}
void Car::steeringAngularVelocitySet(float a){
  steeringAngularVelocity = max(-Defaults::maxSteeringAngularVelocity,min(a,Defaults::maxSteeringAngularVelocity));
  bs->setAngularVelocity(steeringAngularVelocity);
}
void Car::steeringAngularVelocityInc(float inc){
  steeringAngularVelocitySet(inc+steeringAngularVelocity);
}
void Car::velocitySet(float a){
  velocity = a; //max(-maxVelocity,min(a,maxVelocity));
}
void Car::velocityInc(float inc){
  velocitySet(inc+velocity);
}

void  Car ::update(unsigned long dt){ // milliseconds    
    // update steering angle
    steeringAngleInc(steeringAngularVelocity*dt);
  }
  
void Car ::updateSelfDrive(unsigned long dt){ // milliseconds
  jumpSensor().update(dt);
  jumpStatus = jumpSensor().getValue();
  if (jumpStatus != 1){
      frontSensor().update(dt);
      rearSensor().update(dt);
      distanceFrontToWhite = frontSensor().getValue();
      inMiddle = abs(distanceFrontToWhite-Defaults::distanceMiddle2White) <= Defaults::trackerMiddleEpsilon;
      headingDifferenceWithTrack = -atan2(rearSensor().getValue()-frontSensor().getValue(),Defaults::B);
    }
  updateSteeringAndVelocity();
}

void Car::updateSteeringAndVelocity(){
   if(jumpStatus ==0){  // accelleration!!
      intoJumpVelocity = jumping ? intoJumpVelocity : velocity;
      velocitySet(Defaults::jumpSpeed);
      jumping = true;
    }
    if (jumpStatus == 2){  // the eagle has landed, go back to normal speed!
      velocitySet(intoJumpVelocity);
      jumping = false;
    }
    if(jumpStatus==1){  // POP! we are airborne!
      steeringAngularVelocitySet(0);
      steeringAngleSet(0);
      // no steering during the air time!
      return;
    }
    // if inMiddle, turn the steering to the opposite of the angular differnce,
    // else turn the wheels to min( 90-angleDiff/2.0 constrained of course to physical limits
    //float signOfAngle =  distanceFrontToWhite>distanceMiddle2White ? -1.0 : 1.0;
    if (inMiddle){
      //println("In Middle, heading diff", degrees(headingDifferenceWithTrack));
      steeringAngleSet(headingDifferenceWithTrack);
    }
    else{
      //println("Not in Middle, heading diff", degrees(signOfAngle*(-HALF_PI+(headingDifferenceWithTrack)/2.0)));
      steeringAngleSet((distanceFrontToWhite>Defaults::distanceMiddle2White ? -1.0 : 1.0)*(-HALF_PI+(headingDifferenceWithTrack)/2.0));
    }  
  }

#include "BobServo.h"

void BobServo::goLim(int dir){
  // -1 == Counter Clockwise; 1 == Clockwise
  setAngle(dir == -1 ? spec.servoCCStopDegrees : spec.servoCStopDegrees);
}
BobServo::BobServo(int ppin, const ServoSpec &sspec):
                    spec(sspec){
  servo.attach(ppin);
  center();
  #ifdef DEBUG
    spec.display();
  #endif
}                      

BobServo::setAngle(float angle){  // degrees
  // first limit the set angle to the burnout limits
  currentAngle = constrain(reduceAngleDegrees(angle), spec.servoCCStopDegrees,spec.servoCStopDegrees);
  float servoUSValue = map(currentAngle,spec.servoCCStopDegrees,spec.servoCStopDegrees,spec.servoMinBurnout,spec.servoMaxBurnout);
  #ifdef DEBUG
    Serial.print("Setting Servo us: ");
    Serial.print(servoUSValue);
    Serial.print("\tDegrees: ");
    Serial.println(currentAngle);
  #endif
  servo.writeMicroseconds(servoUSValue);
}
float BobServo::getCurrentAngle() const{
  return currentAngle;
}
float BobServo::getCurrentAngularVelocity() const{
  return currentAngularVelocity;
}
const ServoSpec& BobServo::getSpec() const{
  return spec;
}
BobServo::setAngularVelocity(float angularVelocity) { // degrees/sec
  #ifdef DEBUG
    Serial.print("setAngularVelocity called: ");
    Serial.print(angularVelocity);
    Serial.print("\tset to : ");
    Serial.println(constrain(angularVelocity,spec.servoCCMinV,spec.servoCMaxV));
  #endif
  currentAngularVelocity = constrain(angularVelocity,spec.servoCCMinV,spec.servoCMaxV);  
}

void BobServo::update(float dt) { // update angle % dt in seconds
  setAngle(currentAngle + currentAngularVelocity*dt);  
   //#ifdef DEBUG
    Serial.print("updat called, dt:\t");
    Serial.println(dt);
  //#endif
}

void BobServo::update(float angularVelocity,float dt){  // set velocity before updating angle
  setAngularVelocity(angularVelocity);
  update(dt);
}
void BobServo::center(){
  setAngle(0);
  setAngularVelocity(0);
}

void BobServo::goCLimit() { // set to clockwise endpoint
  setAngle(spec.servoCStopDegrees);
}
void BobServo::goCCLim(){ // set to counter clockwise endpoint
  setAngle(spec.servoCCStopDegrees);
}
void BobServo::sweep(int nbLoops){
  const float angleInc = 1,
              timeOut = 10;
  goCCLim();
  // start at cc limit
  int currentDirection = 1,
      count = 0,
      lim = 2*nbLoops;
  while (count < lim){
    setAngle(currentAngle + angleInc*currentDirection);
    delay(timeOut);
    if (abs(currentAngle)== min(abs(spec.servoCCStopDegrees),abs(spec.servoCStopDegrees))){
       currentDirection *= -1;
       count++;
    }
  }
  center();
  #ifdef DEBUG
    Serial.println("exiting sweep");
  #endif
}

float reduceAngleDegrees(float angleDegrees){
  int angleInt = angleDegrees/1;
  float decimal = angleDegrees - angleInt ;
  return (angleInt%360) + decimal;
}



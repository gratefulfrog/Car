#include "BobServo.h"

void BobServo::goLim(int dir){
  // -1 == Counter Clockwise; 1 == Clockwise
  setAngleD(dir == -1 ? spec.servoCCStopDegrees : spec.servoCStopDegrees);
}
BobServo::BobServo(int ppin, const ServoSpec &sspec):
                    spec(sspec){
  servo.attach(ppin);
  center();
  #ifdef DEBUG
    spec.display();
  #endif
}                      

BobServo::setAngleD(float angle){  // degrees
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
BobServo::setAngleR(float angle){  // radians
  setAngleD(degrees(angle));
}
float BobServo::getCurrentAngleD() const{
  return currentAngle;
}
float BobServo::getCurrentAngleR() const{
  return radians(currentAngle);
}
float BobServo::getCurrentAngularVelocityD() const{
  return currentAngularVelocity;
}
float BobServo::getCurrentAngularVelocityR() const{
  return radians(currentAngularVelocity);
}
const ServoSpec& BobServo::getSpec() const{
  return spec;
}
BobServo::setAngularVelocityD(float angularVelocity) { // degrees/milli sec
  #ifdef DEBUG
    Serial.print("setAngularVelocity called: ");
    Serial.print(angularVelocity);
    Serial.print("\tset to : ");
    Serial.println(constrain(angularVelocity,spec.servoCCMinV,spec.servoCMaxV));
  #endif
  currentAngularVelocity = constrain(angularVelocity,spec.servoCCMinV,spec.servoCMaxV);  
}

BobServo::setAngularVelocityR(float angularVelocity) { // degrees/milli sec
 setAngularVelocityD(angularVelocity);
}
void BobServo::update(float dt) { // update angle % dt in seconds
  setAngleD(currentAngle + currentAngularVelocity*dt);  
   //#ifdef DEBUG
    Serial.print("update called, dt:\t");
    Serial.println(dt);
  //#endif
}

void BobServo::updateMicros(float dtMicros){
  // update angle % dt in MICRO seconds using accumulator
  // using accumulator to only call setAngle when outside dead band
  microSecAccumulator += dtMicros;
  float settingAngle = currentAngularVelocity*microSecAccumulator/1000.0;
  float servoDeltaUSValue = map(settingAngle,spec.servoCCStopDegrees,spec.servoCStopDegrees,spec.servoMinBurnout,spec.servoMaxBurnout);
  if (abs(servoDeltaUSValue)>spec.servoDeadBand){
    // then we can do a set!
    setAngleD(currentAngle + settingAngle);
    microSecAccumulator =0;
  }
}

void BobServo::updateD(float angularVelocity,float dt){  // set velocity before updating angle
  setAngularVelocityD(angularVelocity);
  update(dt);
}
void BobServo::updateR(float angularVelocity,float dt){  // set velocity before updating angle
  setAngularVelocityR(angularVelocity);
  update(dt);
}

void BobServo::center(){
  setAngleD(0);
  setAngularVelocityD(0);
}

void BobServo::goCLim() { // set to clockwise endpoint
  setAngleD(spec.servoCStopDegrees);
}
void BobServo::goCCLim(){ // set to counter clockwise endpoint
  setAngleD(spec.servoCCStopDegrees);
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
    setAngleD(currentAngle + angleInc*currentDirection);
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



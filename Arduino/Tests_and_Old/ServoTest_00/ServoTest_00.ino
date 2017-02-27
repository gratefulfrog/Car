#include <Servo.h>
#include "ServoSpec.h"
#include "BobServo.h"
#include "DebugDefs.h"

//#ifdef DEBUG
  const int serialBaudRate = 9600;  // can't do 115200 for some reason??
//#endif

// servo setup parameters
const int servoPin= 8;
BobServo *bs;

unsigned long servoDelay;

// just to inform user wtihout serial montior
void flashLed(){
  for(int i=0;i<10;i++){
    digitalWrite(13,HIGH);
    delay(100);
    digitalWrite(13,LOW);
    delay(100);
  }
}

void doSweep(int n){
  for (int i=0;i<n;i++){
    bs->sweep(1);
  }
  flashLed(); //inform user
}

void setup(){
  #ifdef DEBUG
    Serial.begin(serialBaudRate);
    while(!Serial);
  #endif
  
  // needed to flash the led!
  pinMode(13,OUTPUT);
  // create a servo instance
  bs = new BobServo(servoPin, savoxSpec);
  flashLed();  //inform user

}


// this loop demos the use of angular velocity to postion the servo
// not how the loop cannot keep up if refresh rate is too high

void microLoop(int n){
  unsigned long theMicroTime = micros();
  bs->setAngularVelocity(0.5);
  n *=2;
  while(n){
    if ((bs->getCurrentAngle()<= bs->getSpec().servoCCStopDegrees) ||
         (bs->getCurrentAngle()>=bs->getSpec().servoCStopDegrees)){
      bs->setAngularVelocity(bs->getCurrentAngularVelocity() * -1.0);
      n--;
      }
    unsigned long dtM = (micros()-theMicroTime);
    bs->updateMicros(dtM);  
    theMicroTime=micros();    
  }
  bs->center();
  flashLed();
}

void milliLoop(int n){
  unsigned long theMillisTime = millis();
  float servoDelay =  1000.0/bs->getSpec().servoRefreshRate;
  bs->setAngularVelocity(0.5);
  n *= 2;            
  bool moving = false;   
  while(n){
    if (moving &&
        ((bs->getCurrentAngle()<= bs->getSpec().servoCCStopDegrees) ||
         (bs->getCurrentAngle()>=bs->getSpec().servoCStopDegrees))){
      bs->setAngularVelocity(bs->getCurrentAngularVelocity() * -1.0);
      n--;
      moving = false;
      }
    
    unsigned long dt = (millis()-theMillisTime);
    if (dt>=servoDelay){  //  %refresh rate
      bs->update(dt);  
      theMillisTime=millis(); 
      moving = true; 
    }
  }
  bs->center();
  flashLed();
}

void backForth (int n){
  while(n--){
    bs->goCLim();
    delay(200);
    bs->goCCLim();
    delay(200);
  }
  bs->center();
  flashLed();
}

void loop(){
  doSweep(1);
  backForth(2);
  microLoop(1);
  backForth(2);
  milliLoop(1);
  backForth(5);
}


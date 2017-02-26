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

unsigned long theTime,
              servoDelay;

// just to inform user wtihout serial montior
void flashLed(){
  for(int i=0;i<10;i++){
    digitalWrite(13,HIGH);
    delay(100);
    digitalWrite(13,LOW);
    delay(100);
  }
}

void setup(){
  //#ifdef DEBUG
    Serial.begin(serialBaudRate);
    while(!Serial);
  //#endif
  
  // needed to flash the led!
  pinMode(13,OUTPUT);
  // create a servo instance
  bs = new BobServo(servoPin, savoxSpec);
  flashLed();  //inform user

  // do a single sweep to show it works ok!
  bs->sweep(1);
  flashLed(); //inform user
  
  // set up for angular velocity sweeping in loop
  bs->setAngularVelocity(500);
  servoDelay =  1000.0/bs->getSpec().servoRefreshRate;
  theTime = millis();
}


// this loop demos the use of angular velocity to postion the servo
// not how the loop cannot keep up if refresh rate is too high

void loop(){
  //float ca = bs->getCurrentAngle();
  // if current angle has reached a limit, reverse the direction of traval
  if ((bs->getCurrentAngle()<= bs->getSpec().servoCCStopDegrees) ||
      (bs->getCurrentAngle()>=bs->getSpec().servoCStopDegrees)){
    bs->setAngularVelocity(bs->getCurrentAngularVelocity() * -1.0);
    }
  unsigned long dt = (millis()-theTime);
  if (dt>=servoDelay){  //  refresh rate
    bs->update(dt/1000.0);  
    theTime=millis();  
  }
}

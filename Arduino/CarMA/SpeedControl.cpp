#include "SpeedControl.h"


SpeedControl::SpeedControl(int pin): speedPin(pin){
  pinMode(speedPin,OUTPUT);
  lastFlash= millis();
}

int SpeedControl::setSpeed(int s){
  speed = s;
}

void SpeedControl::update(){
   if (millis()-lastFlash>100000/speed){
    state ^=1;
    digitalWrite(speedPin,state);
    lastFlash=millis();
  }
}


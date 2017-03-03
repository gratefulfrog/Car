 /* CarSimMA
  * Autonomous Car Simulation and DEvt. platform
  * Arduino version
  * this verison implements various experiments in modal control, doesn't really work yet 2017 02 09...
  */

#include "App.h"

Defaults &defaults =  *(new Defaults());
App &app = *(new App(defaults));

unsigned long millisLoopMinTime =0,
              lastActionTime = 0;

int baudRate = 115200;

void frameRate(unsigned long rate){
  millisLoopMinTime = round(1000./rate);
}

void setup(){
  //Serial.begin(baudRate);
  //while(!Serial);
  frameRate(50);  // nb steps per second
  lastActionTime = millis();
}

void stepSerial(){}

void loop(){
  unsigned long dt= millis()-lastActionTime; 
  if (dt >= millisLoopMinTime){
    app.mainLoop(dt);
    lastActionTime = millis();
  }
  stepSerial();
}

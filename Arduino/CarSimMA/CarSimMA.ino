 /* CarSimMA
  * Autonomous Car Simulation and DEvt. platform
  * Arduino version
  * this verison implements various experiments in modal control, doesn't really work yet 2017 02 09...
  */


Defaults defaults;
App app;

unsigned long millisLoopMinTime =0;

int baudRate = 115200;

void frameRate(unsigned long rate){
  millisLoopMinTime = round(1000./rate);
}

void setup(){
  Serial.begin(baudRate);
  while(!Serial);
  frameRate(50);  // nb steps per second
  defaults = new Defaults();
  app = new App(defaults);
  lastActionTime = millis();
}

void stepSerial(){

void loop(){
  if (millis()-lastActionTime >=millisLoopMinTime){
    app.mainLoop();
    lastActionTime = millis();
  }
  stepSerial();
}

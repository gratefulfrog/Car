 /* CarSimMA
  * Autonomous Car Simulation and DEvt. platform
  * Arduino version
  * this verison implements various experiments in modal control, doesn't really work yet 2017 02 09...
  * and works on 2017 03 08
  */

#include "App.h"
#include "HeartBeat.h"
#include "SpeedControl.h"
#include "BobServo.h"
#include "ServoSpec.h"
#include "MsgMgr.h"

//App &app = *(new App());
HeartBeat *hb;// = *(new HeartBeat(Defaults:: heartBeatPin));
SpeedControl *sc; // = *(new SpeedControl(Defaults:: speedPin));
BobServo  *bs; 
MsgMgr *msgMgr;


const int curSpeed = 500;

void setup(){
  //pinMode(13,OUTPUT);
  hb = new HeartBeat(Defaults:: heartBeatPin);
  sc = new SpeedControl(Defaults:: speedPin);
  msgMgr = new MsgMgr();
  bs = new BobServo(Defaults::servoPin, savoxSpec);
  //sc.setSpeed(curSpeed);
  bs->sweep(1);
}


void loop(){
  msgMgr->stepLoop();
  hb->beat();
  sc->update();
}

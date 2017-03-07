/* ReceiveOSCSerial
* Set the LED according to incoming OSC control
* tested with Processing program SimpleOSCWriteToSerial
* implmentet heartbeat to ensure that it could do other stuff!
* and a class to encapsulate it all!
*/
#include <Arduino.h>

#include "MsgMgr.h"
#include "Defaults.h"

MsgMgr *msgMgr;

void setup() {
  initDefaults();
  msgMgr = new MsgMgr();
  flashLed(3);  // to indicate ready!
}

//reads and dispatches the incoming message
void loop(){ 
  msgMgr->stepLoop();
  heartBeat();
}



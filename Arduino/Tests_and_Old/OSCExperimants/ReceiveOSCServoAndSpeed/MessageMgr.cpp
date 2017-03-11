#include "MessageMgr.h"

extern void flashLed(int n);

MessageMgr::MessageMgr(SLIPEncodedSerial &SLIPS, void (*callbackFunc)(OSCMessage &), int baudrate){
  callback = callbackFunc;
  SLIPSerial = SLIPS;

  SLIPSerial.begin(baudrate);
  while(!Serial);
}

void MessageMgr::stepIncoming(){
  //flashLed(2);

  OSCMessage msgIN;
  int size;
  bool recd = false;
  while(!SLIPSerial.endofPacket()){
    if( (size =SLIPSerial.available()) > 0){
        while(size--)
          msgIN.fill(SLIPSerial.read());
    }
    recd=true;
  }
  if(recd && !msgIN.hasError()){
    //flashLed(2);
    msgIN.dispatch("/led", callback);
    recd=false;
  }
}



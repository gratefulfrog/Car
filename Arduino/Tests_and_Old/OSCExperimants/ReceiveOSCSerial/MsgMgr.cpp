#include "MsgMgr.h"

void LEDcontrol(OSCMessage &msg){
  digitalWrite(ledPin, msg.getInt(0));
}

MsgMgr::MsgMgr(){
  SLIPSerial = new SLIPEncodedSerial(Serial);
  SLIPSerial->begin(115200);
}

MsgMgr::stepLoop(){
  if (SLIPSerial->available() > 0){
    OSCMessage msgIN;
    int size;
    while(!SLIPSerial->endofPacket()){
      if( (size =SLIPSerial->available()) > 0){
          while(size--)
            msgIN.fill(SLIPSerial->read());
      }
    }
    
    if(!msgIN.hasError()){
      msgIN.dispatch("/led", LEDcontrol);
    }
  }
}


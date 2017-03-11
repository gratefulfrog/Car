#include "MsgMgr.h"

/*
void LEDcontrol(OSCMessage &msg){
  digitalWrite(ledPin, msg.getInt(0));
}
*/
#include "SpeedControl.h"
#include "BobServo.h"

extern SpeedControl *sc;
extern BobServo  *bs; 

void doControls(OSCMessage &msg){
  //int val = msg.getInt(0);
  float speedV = msg.getFloat(0),
        angleR = msg.getFloat(1);
  //digitalWrite(13,val);
  sc->setSpeed(speedV);
  bs->setAngleR(-angleR);
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
      msgIN.dispatch("/led", doControls);
    }
  }
}


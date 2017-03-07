/* ReceiveOSCSerial
* Set the LED according to incoming OSC control
* tested with Processing program SimpleOSCWriteToSerial
*/
#include <Arduino.h>
#include "MessageMgr.h"

SLIPEncodedSerial SLIPSerial(Serial);

MessageMgr *msgMgr;

void LEDcontrol(OSCMessage &msg){
  //flashLed(2);
  digitalWrite(13, msg.getInt(0));
}

void flashLed(int n){
  for (int i=0;i<n;i++){
      digitalWrite(13,HIGH);
      delay(50);
      digitalWrite(13,LOW);
      delay(50);
    }  
    digitalWrite(13,HIGH);
    delay(1000);
    digitalWrite(13,LOW);
}

void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(115200);
  //msgMgr = new MessageMgr(SLIPSerial,LEDcontrol,115200);
  flashLed(3);  // to indicate ready!
}

//reads and dispatches the incoming message
void loop(){ 
  //flashLed(3);
  if( (Serial.available()) > 0){
    //msgMgr->stepIncoming();
    flashLed(2);
  }
}



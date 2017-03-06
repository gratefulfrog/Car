/* ReceiveOSCSerial
* Set the LED according to incoming OSC control
* tested with Processing program SimpleOSCWriteToSerial
*/
#include <Arduino.h>

#include <OSCMessage.h>
#include <SLIPEncodedSerial.h>

SLIPEncodedSerial SLIPSerial(Serial);

void LEDcontrol(OSCMessage &msg){
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
  SLIPSerial.begin(115200);
  while(!Serial);
  flashLed(3);  // to indicate ready!
}

//reads and dispatches the incoming message
void loop(){ 
  OSCMessage msgIN;
  int size;
  while(!SLIPSerial.endofPacket()){
    if( (size =SLIPSerial.available()) > 0){
        while(size--)
          msgIN.fill(SLIPSerial.read());
    }
  }
  
  if(!msgIN.hasError()){
    msgIN.dispatch("/led", LEDcontrol);
  }
}



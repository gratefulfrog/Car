#include <SLIPEncodedSerial.h>
#include <OSCTiming.h>
#include <OSCBundle.h>
#include <OSCBoards.h>
#include <OSCMatch.h>
#include <OSCData.h>
#include <SLIPEncodedSerial.h>
#include <OSCMessage.h>

// let's try to capture BT messages from android processing
// this receives characters from any android processing sketch and displays them as they come on the serial monitor

// sending something back is not so easy...

#include <SoftwareSerial.h>  

const int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
const int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3

SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

SLIPEncodedSerial SLIPSerial(Serial);

void setup(){
  SLIPSerial.begin(9600); 
  Serial.begin(9600);
  bluetooth.begin(9600);
    
}

OSCMessage msgIn
;
void loop(){
   while(!SLIPSerial.endofPacket()){
    int size = SLIPSerial.available();
    if (size > 0){
        //fill the msg with all of the available bytes
        while(size--){
            msgIn.fill(SLIPSerial.read());
        }
    }
   }
   if (msgIn.isInt(0) && msgIn.isInt(1)){ 
     Serial.print('(');
     Serial.print(msgIn.getInt(0));
     Serial.print(',');
     Serial.print(msgIn.getInt(1));
     Serial.println(')');
    OSCMessage msg("/remoteMouse/");
    msg.add(5+msgIn.getInt(0));
    msg.add(5+msgIn.getInt(1));
    msg.send(Serial);
   }
}


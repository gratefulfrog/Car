// let's try to capture BT messages from android processing
// this receives characters from any android processing sketch and displays them as they come on the serial monitor

// sending something back is not so easy...

#include <SoftwareSerial.h>  

const int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
const int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3

SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);  
}

void loop(){
   if(bluetooth.available()>0)  {
    Serial.print(char(bluetooth.read()));
   }
}


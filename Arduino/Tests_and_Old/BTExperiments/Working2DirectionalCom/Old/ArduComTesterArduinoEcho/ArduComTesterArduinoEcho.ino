// this captures BT messages from android processing
// this receives characters from any android processing sketch with the BT module on pins 0,1
// and echos them back as they come in.

// this is tested on 2017 02 23 with the ArduComTesterProcessing sketch

// pin 0 is Adruino RX, Bluetooth TX
// pin 1 is Adruino TX, Bluetooth RX

void setup(){
  Serial.begin(115200);

}

void loop(){
   if(Serial.available()>0)  {
    Serial.print(char(Serial.read()));
   }
}


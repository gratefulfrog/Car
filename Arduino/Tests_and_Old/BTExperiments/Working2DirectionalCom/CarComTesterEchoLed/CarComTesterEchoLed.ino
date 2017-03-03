// this captures BT messages from android processing
// this receives characters from any android processing sketch with the BT module on pins 0,1
// and echos them back as they come in.

// this is tested on 2017 02 23 with the ArduComTesterProcessing sketch

// pin 0 is Adruino RX, Bluetooth TX
// pin 1 is Adruino TX, Bluetooth RX

#include <Arduino.h>

const int ledPin = 13;

void setup(){
  Serial.begin(115200);
  pinMode(ledPin,OUTPUT);
}

const int inLimit = 8;

char incoming[inLimit];
int nbIn =0;

bool addChar(char c){
  incoming[nbIn++] = c;
  bool res = (nbIn == inLimit);
  return res;
}

void loop(){
  if(Serial.available()>0)  {
    if(addChar(char(Serial.read()))){
      for (int i=0;i<8;i++){
        Serial.print(incoming[i]);
      }
      if(incoming[1] == '1'){
        digitalWrite(ledPin,HIGH);
      }
      else{
        digitalWrite(ledPin,LOW);
      }
      nbIn=0;
    } 
  }
}


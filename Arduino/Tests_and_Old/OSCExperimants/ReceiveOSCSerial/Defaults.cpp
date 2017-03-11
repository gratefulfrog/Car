#include "Defaults.h"


const int heartBeatPin = 12,
          ledPin       = 13;

void initDefaults(){
  pinMode(ledPin, OUTPUT);
  pinMode(heartBeatPin,OUTPUT);
}

void heartBeat(){
  static int state = 0;
  static unsigned long lastBeat = millis();
  const static int timeOut = 500;

  if (millis()-lastBeat>timeOut){
    state ^=1;
    digitalWrite(heartBeatPin,state);
    lastBeat=millis();
  }
}

void flashLed(int n){
  for (int i=0;i<n;i++){
      digitalWrite(ledPin,HIGH);
      delay(50);
      digitalWrite(ledPin,LOW);
      delay(50);
    }  
    digitalWrite(ledPin,HIGH);
    delay(1000);
    digitalWrite(ledPin,LOW);
}

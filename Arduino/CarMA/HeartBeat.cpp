#include "HeartBeat.h"

    const int hbPin,
              timeOut =  500;
    int state = 0;
    unsigned long lastBeat;
HeartBeat::HeartBeat(int pin): hbPin(pin){
  pinMode(hbPin,OUTPUT);
  lastBeat=millis();
}


void HeartBeat::beat(){
  if (millis()-lastBeat>timeOut){
    state ^=1;
    digitalWrite(hbPin,state);
    lastBeat=millis();
  }
}    


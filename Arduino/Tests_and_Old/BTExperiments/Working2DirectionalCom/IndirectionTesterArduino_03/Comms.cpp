#include "Comms.h"

void Comms::send(char* outRaw){
  char outgoing[10];
  for (byte i=0;i<9;i++){
    outgoing[i] = outRaw[i];
  }
  outgoing[9] = '\0';
  Serial.print(outgoing);
} 

bool Comms::addChar(char c){
  incoming[nbIn++] = c;
  bool res = (nbIn == inLimit);
  return res;
}

Comms::Comms(){
  Serial.begin(115200);
  while(!Serial);
  nbIn=0;
}

void  Comms::stepLoop(){
  if(Serial.available()>0)  {
    if(addChar(char(Serial.read()))){
      // then we are ready to process!
      MessageMgr::processMessage(Comms::incoming);
      setLed();
      nbIn=0;
    } 
  }
}
void Comms::setLed(){
  if(incoming[3] == '1'){
    digitalWrite(ledPin,HIGH);
  }
  else{
    digitalWrite(ledPin,LOW);
  }
}


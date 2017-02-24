#include "Comms.h"
 
void Comms::send(char* outRaw){
  char outgoing[10];
  for (byte i=0;i<9;i++){
    outgoing[i] = outRaw[i];
  }
  outgoing[9] = '\0';
  Serial.println(outgoing);
} 


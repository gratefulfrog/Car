/* This is an example of how to use the ArduComSlave class.
 * First we have to define a function that will generate the response to incoming messages
 * 'prcoMsg' is just that: It prepends alternatively an 'e' or an 'x' to the incoming message
 * Then we declare a pointer to an ArduComSlave, 
 * we instatiate the ArduComSlave, then call its doInit method. Upon exit from that, it is ready to go.
 * Note that we have used 'Serial' as the serial object port.
 * in the loop(), we only have to call stepLoop() and the rest is magic.
 * test this by inputing at the Serial Monitor:
 * first type an 'A' to confirm init,
 * then type sequences of 5 chars and observing the responses.
 */

#include "ArduCom.h"

ArduComSlave *com;


boolean procMsg(char *buf, char*, int bufSize){
  // just for creating errors,
  // this is an 'ArduComResponseFunc'
    buf[0] =  'x';
    
    if (buf[1]  =='s'){
      digitalWrite(13,HIGH);
    }
    else if (buf[1] == 'g'){
      digitalWrite(13,LOW);
    }
    else{ 
      for (int i=0;i<5;i++){
        digitalWrite(13,HIGH);
        delay(100);
        digitalWrite(13,LOW);
        delay(100); 
      }
    }
    
  return true;
}
  


//////////////  std functions ////////////////

void setup(){
  pinMode(13,OUTPUT);
  com = new ArduComSlave(&Serial,&procMsg,ARDUCOM_MSGSIZE);
  com->doInit();
}

void loop(){
  com->stepLoop();
}


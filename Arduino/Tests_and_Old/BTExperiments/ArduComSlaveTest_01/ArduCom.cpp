#include "ArduCom.h"

boolean procReply(char *reply, char *sent, int replySize){
  // This is part of the ArduCom protocol suite.
  // if it starts with e, then not ok!
  // otherwise, if any of the chars do not match the last sent, i.e. the top of the queue, 
  // then not ok.
  if(reply[0] == 'e'){
    return false;
  }
  boolean ret = true;
  for (int i=1; i< replySize;i++){
    if (sent[i-1] != reply[i]){
      ret = false;
      break;
    }
  }
  return ret;
}

///////////////////////////////////////////////////////////////////////////
///////////////////  Human Monitoring Stuff ///////////////////////////////
///////////////////////////////////////////////////////////////////////////
 void ArduCom::msg(String s) {
  // send stuff to the serial terminal for human observation
  Serial.println(s);
}

void  ArduCom::msg(String s, char *c, int len)  {
  // send stuff to the serial terminal for human observation
  // allows a string plus a un-terminated char array to be sent
  char buff[len+1];
  for (int i=0;i< len;i++){
    buff[i]=  c[i];
  }
  buff[len] = '\0';
  msg (s + buff);
}

void ArduCom::respond(){
  //port->write((byte*)responseBuffer,responseSize);
  for (int i=0;i<responseSize;i++){
    port->write(msgBuffer[i]);
  } 
} 

void ArduComSlave::executeMsgString(){
  // after each atomic incoming msg, reply
  (*rFunc)(msgBuffer,NULL,msgSize);
  respond();
}
  

ArduCom::ArduCom(HardwareSerial *p,
     ArduComResponseFunc f, 
     int mSz): port(p), msgSize(mSz), responseSize(mSz+1){
  msgBuffer = new char[responseSize];
  initialized = false;
  rFunc = f;
}

void ArduCom::clearIncoming(){
  while (port->read() != -1);
}

ArduComSlave::ArduComSlave(HardwareSerial *p,
         ArduComResponseFunc f, 
         int mSz): ArduCom::ArduCom(p,f,mSz){
  currentCharCount = 1;
}

void ArduComSlave::doInit() {
  // setup the port
  port->begin(baudRate);
  while(!*port);
  // send initChar and wait for response
  while(!initialized){
    port->write(initChar);
    delay(100);
    if(port->available()>0){
      char c = port->read();
      if (c !=initChar){
        msgBuffer[currentCharCount++] = c;
      }      
      initialized = true;
    }
  }
}

void ArduComSlave::stepLoop(){
  //processIncomingAtom();
  if (currentCharCount == responseSize) {
    executeMsgString();
    currentCharCount = 1;
  }

  //readIntoAtom();
  if (port->available() > 0) {
    // read one char and add it to the buffer if ok:
    char c = port->read();
    if (c !=initChar){
      msgBuffer[currentCharCount++] = c;
    }
  }
}



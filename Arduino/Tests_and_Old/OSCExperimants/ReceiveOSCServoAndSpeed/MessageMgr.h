#ifndef MESSAGEMGR_H
#define MESSAGEMGR_H

#include <Arduino.h>
#include <HardwareSerial.h>

#include <OSCMessage.h>
#include <SLIPEncodedSerial.h>

class MessageMgr{
  protected:
     SLIPEncodedSerial &SLIPSerial;
     void (*callback)(OSCMessage &);

  public:
    MessageMgr(SLIPEncodedSerial &SLIPS, void (*callbackFunc)(OSCMessage &), int baudrate);
    void stepIncoming();  
};

#endif

#ifndef MSGGR_H
#define MSGGR_H

#include <Arduino.h>

#include "Defaults.h" 

#include <OSCMessage.h>
#include <SLIPEncodedSerial.h>

class MsgMgr{
  protected:
    SLIPEncodedSerial *SLIPSerial;

  public:
    MsgMgr();
    stepLoop();
};

#endif

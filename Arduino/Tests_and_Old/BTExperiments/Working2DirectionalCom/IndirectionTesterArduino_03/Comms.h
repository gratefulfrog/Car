#ifndef COMMS_H
#define COMMS_H

#include <Arduino.h>
#include "MessageMgr.h"


class Comms{
  protected:
    static const int inLimit= 8,
                     ledPin = 13;
    char incoming[inLimit];
    int nbIn;
    bool addChar(char c);
    
  public:
    Comms();
    void stepLoop();
    void setLed();
    static void send(char*);
    
};

#endif

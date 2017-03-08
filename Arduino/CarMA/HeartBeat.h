#ifndef HEARTBEAT_H
#define HEARTBEAT_H

#include <Arduino.h>
#include "Defaults.h"
#include "DebugDefs.h"

class HeartBeat{
  protected:
    const int hbPin,
              timeOut =  500;
    int state = 0;
    unsigned long lastBeat;
  public:
    HeartBeat(int pin);
    void beat();    
};



#endif

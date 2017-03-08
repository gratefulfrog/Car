#ifndef SPEEDCONTROL_H
#define SPEEDCONTROL_H

#include <Arduino.h>
#include "Defaults.h"
#include "DebugDefs.h"

class SpeedControl{
  protected:
    const int speed2FlashFactor = 100,
              speedPin;
    
    int state = 0,
        speed = 0;
    unsigned long lastFlash;
  public:
    SpeedControl(int pin);
    int setSpeed(int s);
    void update();    
};

#endif

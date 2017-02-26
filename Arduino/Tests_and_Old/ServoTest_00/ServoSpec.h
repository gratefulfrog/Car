#ifndef SERVOSPEC_H
#define SERVOSPEC_H

#include <Arduino.h>
#include "DebugDefs.h"

class ServoSpec{
  public:
    const int servoDeadBand,      // us
              servoMinBurnout,    // us = spec + dead band
              servoMaxBurnout,    // us = spec - dead band
              servoCenter,        // us
              servoAngularRange,  // degrees from burnout to burnout
              servoRefreshRate;   //Hz
    const float maxAngularVelocity; // degrees/milli sec
    
    // derived servo parameters.
    const float servoCStopDegrees,   // degrees from 0 in center
                servoCCStopDegrees,  // -degrees from 0 in center
                servoCenterDegrees,
                servoCMaxV, 
                servoCCMinV;
  
    ServoSpec(int deadBand,          // us
              int minBurnout,        // us not including dead band
              int maxBurnout,        // us not including dead band
              int center,            // us
              int angularRange,      // degrees from burnout to burnout
              float angularVelocity,   // degrees/millis sec
              int refreshRate);      // Hz
    #ifdef DEBUG
      void display();
    #endif
  
};

extern const ServoSpec savoxSpec;

#endif

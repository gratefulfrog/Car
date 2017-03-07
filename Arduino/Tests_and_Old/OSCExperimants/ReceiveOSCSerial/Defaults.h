#ifndef DEFAULTS_H
#define DEFAULTS_H

#include <Arduino.h>

extern const int heartBeatPin,
                 ledPin;
                 
extern void initDefaults();
extern void heartBeat();
extern void flashLed(int n);

#endif

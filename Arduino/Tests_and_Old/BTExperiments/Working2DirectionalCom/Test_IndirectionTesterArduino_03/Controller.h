#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <Arduino.h>
#include "SuperIndirectable.h"

class Controller{
  // base class is concrete but just provides and update method!
  public:
    virtual float update(float mv, unsigned long dt); // dt is milliseconds
};

class ModalController: public Controller{
  protected:
    const byte nbModes;
    byte currentMode;

  public:
    ModalController(unsigned int nbMds = 1): nbModes(nbMds),currentMode(0){}
    virtual float update(float mv, unsigned long dt); // dt is milliseconds
};

class ModalPidController: public ModalController{
  /* implemtation od discrete pid algo as per 
   * https://en.wikipedia.org/wiki/PID_controller#Pseudocode
   * PID tuning as per Ziegler–Nichols method
   * https://en.wikipedia.org/wiki/Ziegler%E2%80%93Nichols_method 
   */
  protected:
    SuperIndirectable PidParams[][3];
    float previousError = 0,
          integral = 0,
          sp = 0; 

  public:
    ModalPidController(float pidParams[][3], byte nbModes = 1);
    virtual float update(float mv, unsigned long dt); // dt is milliseconds
};

#endif

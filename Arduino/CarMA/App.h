#ifndef APP_H
#define APP_H

#include "Car.h"
#include "Defaults.h"

class App{
  protected:
    Car &car;
    bool manualSteering = false;

  public:
    App::App(Defaults &df);
    bool setManualSteering(bool setIt = true);  
    void mainLoop(unsigned long dt); //milliseconds
};

#endif


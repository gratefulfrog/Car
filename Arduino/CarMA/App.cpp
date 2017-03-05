#include "App.h"
          
App::App(): car(*(new Car())){
}

bool App::setManualSteering(bool setIt = true){
  return manualSteering = setIt;
}
  
void App::mainLoop(unsigned long dt){
  car.update(dt);
  if (!manualSteering){
    car.updateSelfDrive(dt);
  }
}
  

                

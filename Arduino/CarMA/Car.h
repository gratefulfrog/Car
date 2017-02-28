#ifndef CAR_H
#define CAR_H

#include "Defaults.h"

class Car{
  protected:
    Defaults &defaults;
  public:
    Car (Defaults& df): defaults(df){}
    void  update(unsigned long dt);  // milliseconds
    void updateSelfDrive(unsigned long dt);
};

#endif

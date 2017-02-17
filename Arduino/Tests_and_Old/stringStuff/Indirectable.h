#ifndef INDIRECTABLE_H
#define INDIRECTABLE_H

#include <Arduino.h>

class Indirectable{
  protected:
    float val;

    
    static const int maxI = 30;
    static Indirectable * iVec[maxI];
    static int nextI;

    static void recordInstance(Indirectable *instance);
    
  public:
    Indirectable();
    Indirectable(float v);
    
    static void showAll();
    
    float get() const;
    float set(float v);
    float addV(float v);
    float timesV(float v);    
};
#endif

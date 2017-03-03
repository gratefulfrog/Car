#ifndef INDIRECTABLE_H
#define INDIRECTABLE_H

#include <Arduino.h>

typedef float (*rFuncPtr)(int, float);
// temp for testing
extern rFuncPtr fp0;

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

    // these are the public instance methods
    float get() const;
    float set(float v);
    float addV(float v);
    float minusV(float v);
    float timesV(float v);
    float divV(float v);    

    // these are the public class methods
    static Indirectable *getInstance(int index);
    static void showAll();
    static bool indexOk(int);

    // note that the static version of get takes an unused float argument so that
    // it will fit the typede sFuncPtr
    static float get(int index, float);
    static float set(int index,float v);
    static float addV(int index,float v);
    static float minusV(int index, float v);
    static float timesV(int index, float v);
    static float divV(int index, float v);
};

#endif

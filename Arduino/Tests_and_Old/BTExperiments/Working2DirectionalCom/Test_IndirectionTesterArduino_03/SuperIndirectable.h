#ifndef SUPERINDIRECTABLE_H
#define SUPERINDIRECTABLE_H

#include <Arduino.h>
#include "Spec.h"

class SuperIndirectable{
  protected:
  // statics
    static const int maxI = 30;
    static SuperIndirectable * iVec[maxI];
    static int nextI;

    static void recordInstance(SuperIndirectable *instance);

  // members
    float val;
    virtual float valSet(float v){val=v;}
    
  public:
    SuperIndirectable(){recordInstance(this);}
  //members
    float set(float val) { return valSet(val);}
    float get() const { return val;}
    float plusV(float v){ return valSet(val+v);}
    float minusV(float v){ return valSet(val-v);}
    float multV(float v){ return valSet(val*v);}
    float divV(float v){ return valSet(val/v);}

  // statics
    static SuperIndirectable *getInstance(int index);
    static void showAll();
    static bool indexOk(int);
    // note that the static version of get takes an unused float argument so that
    // it will fit the typede sFuncPtr
    static float get(int index, float);
    static float set(int index,float v);
    static float plusV(int index,float v);
    static float minusV(int index, float v);
    static float multV(int index, float v);
    static float divV(int index, float v);
};

class SISpec:public SuperIndirectable{
  protected:
    const Spec &spec;
  public:
    SISpec(Spec &s): spec(s){/* cannot call valSet because child instance does not yet exist */}
};

class SIAngle:public SISpec{
  protected:
    virtual float valSet(float v){
      return val = constrain(v,spec.getMinAngle(),spec.getMaxAngle());
    }
  public:
    SIAngle(float v,Spec &s):SISpec(s){valSet(v);}
};

class SIAngularVelocity:public SISpec{
  protected:
    virtual float valSet(float v){
      return val = constrain(v,spec.getMinAngularVelocity(),spec.getMaxAngularVelocity());
    }
  public:
    SIAngularVelocity(float v,Spec &s):SISpec(s){valSet(v);}
};
#endif


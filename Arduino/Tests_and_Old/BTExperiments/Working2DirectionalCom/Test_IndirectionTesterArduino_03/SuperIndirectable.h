#ifndef SUPERINDIRECTABLE_H
#define SUPERINDIRECTABLE_H

#include <Arduino.h>
#include "Spec.h"

class SuperIndirectable{
  protected:
  // statics
    static const byte maxI = 30;
    static SuperIndirectable * iVec[maxI];
    static byte nextI;

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
    static SuperIndirectable *getInstance(byte index);
    static void showAll();
    static bool indexOk(byte);
    // note that the static version of get takes an unused float argument so that
    // it will fit the typede sFuncPtr
    static float get(byte index, float);
    static float set(byte index,float v);
    static float plusV(byte index,float v);
    static float minusV(byte index, float v);
    static float multV(byte index, float v);
    static float divV(byte index, float v);
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


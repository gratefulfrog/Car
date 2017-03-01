#ifndef CAR_H
#define CAR_H
#include "SuperIndirectable.h"

class Car{
  public:
    SIAngle angle;
    SIAngularVelocity angularVelocity;

    Car(Spec &sp): angle(0,sp), angularVelocity(0,sp){}
    Car(float a,float av,Spec &sp): angle(a,sp), angularVelocity(av,sp){}
};
#endif

#include "indirection.h"

// protected:

//    public:
Indirect::Indirect(int nbFloats){
  floatSize = nbFloats;
  floatVec = new float* [nbFloats];
  
}
void Indirect::addElt(float* val){
  // one of these should be NULL, the other is added
   if (nextFreeFloat<floatSize){
    floatVec[nextFreeFloat++] = val;
  }
}

void Indirect::set(int ind, float* val){   
  floatVec[ind] = val;
}
float* Indirect::get(int ind) const{
  return floatVec[ind];
}


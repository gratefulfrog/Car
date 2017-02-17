#include "indirection.h"
#include "app.h"

// protected:
extern Indirect *app;

// statics
Indirect* Indirect::indirectVec[NB_INDIRECTS];
int Indirect::lastID = 0;

/*
Indirect* Indirect::dispatch(int ind) const{
  int cur = 0;
  for (int i=0;i< NB_INDIRECTS;i++){
    cur += Indirect::indirectVec[i]->floatSize;
    if (ind<cur){
      return indirectVec[i];
    }
  }
  return NULL;
}
*/
//    public:
Indirect::Indirect(int nbFloats): id(Indirect::lastID){
  floatSize = nbFloats;
  floatVec = new float* [nbFloats];
  Indirect::indirectVec[Indirect::lastID++] = this;
  
}
void Indirect::addElt(float* val){
  // one of these should be NULL, the other is added
   if (nextFreeFloat<floatSize){
    floatVec[nextFreeFloat++] = val;
  }
}
void Indirect::set(int ind, float val){   
  *(indirectVec[id]->floatVec[ind]) = val;
}
float Indirect::get(int ind) const{
  return *(indirectVec[id]->floatVec[ind]);
}


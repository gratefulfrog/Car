#include "Indirectable.h"

Indirectable *Indirectable::iVec[Indirectable::maxI];
int Indirectable::nextI = 0;

void Indirectable::recordInstance(Indirectable *instance){
  // add instane to vector, or fail quietly...
  if (Indirectable::nextI< Indirectable::maxI){
    Indirectable::iVec[nextI++] =  instance;
  }
}

void Indirectable::showAll(){
  for(int i=0;i<Indirectable::nextI;i++){
    Serial.println(iVec[i]->get());
  }
}

Indirectable::Indirectable(){
  val=0;
  Indirectable::recordInstance(this);
}
Indirectable::Indirectable(float v){
  val=v;
  Indirectable::recordInstance(this);
}
float Indirectable::get() const { 
  return val;
}
float Indirectable::set(float v){
  return val = v;
}
float Indirectable::addV(float v){
  return val += v;
}
float Indirectable::timesV(float v){
  return val *= v;    
}


#include "Indirectable.h"

Indirectable *Indirectable::iVec[Indirectable::maxI];
int Indirectable::nextI = 0;

void Indirectable::recordInstance(Indirectable *instance){
  // add instane to vector, or fail quietly...
  if (Indirectable::nextI< Indirectable::maxI){
    Indirectable::iVec[nextI++] =  instance;
  }
}

Indirectable *Indirectable::getInstance(int index){
  // return index or NULL if failure
  if (index>=Indirectable::nextI){
    return NULL;
  }
  else {
    return Indirectable::iVec[index];
  }
}

void Indirectable::showAll(){
  for(int i=0;i<Indirectable::nextI;i++){
    Serial.println(iVec[i]->get());
  }
}

bool Indirectable::indexOk(int i){
  return i < nextI;
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
float Indirectable::minusV(float v){
  return val -= v;
}
float Indirectable::timesV(float v){
  return val *= v;    
}
float Indirectable::divV(float v){
  return val /= v;    
}

float Indirectable::get(int index,float) { 
  #ifdef DEBUG
  Serial.println("Indirectable::get(" + String(index) +")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->get()));
  #endif
  return Indirectable::getInstance(index)->get();
}
float Indirectable::set(int index,float v){
  #ifdef DEBUG
  Serial.println("Indirectable::set(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->set(v)));
  #endif
  return Indirectable::getInstance(index)->set(v);
}
float Indirectable::addV(int index,float v){
  #ifdef DEBUG
  Serial.println("Indirectable::addV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->addV(v)));
  #endif
  return Indirectable::getInstance(index)->addV(v);
}
float Indirectable::minusV(int index,float v){
  #ifdef DEBUG
  Serial.println("Indirectable::minusV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->minusV(v)));
  #endif
  return Indirectable::getInstance(index)->minusV(v);
}
float Indirectable::timesV(int index,float v){
  #ifdef DEBUG
  Serial.println("Indirectable::timesV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->timesV(v)));
  #endif
  return Indirectable::getInstance(index)->timesV(v);

}
float Indirectable::divV(int index,float v){
  #ifdef DEBUG
  Serial.println("Indirectable::divV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(Indirectable::getInstance(index)->divV(v)));
  #endif
  return Indirectable::getInstance(index)->divV(v);
}


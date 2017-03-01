#include "SuperIndirectable.h"

SuperIndirectable *SuperIndirectable::iVec[SuperIndirectable::maxI];
int SuperIndirectable::nextI = 0;

void SuperIndirectable::recordInstance(SuperIndirectable *instance){
  // add instane to vector, or fail quietly...
  if (SuperIndirectable::nextI< SuperIndirectable::maxI){
    SuperIndirectable::iVec[nextI++] =  instance;
  }
}

SuperIndirectable *SuperIndirectable::getInstance(int index){
  // return index or NULL if failure
  if (index>=SuperIndirectable::nextI){
    return NULL;
  }
  else {
    return SuperIndirectable::iVec[index];
  }
}

void SuperIndirectable::showAll(){
  for(int i=0;i<SuperIndirectable::nextI;i++){
    Serial.println(iVec[i]->get());
  }
}

bool SuperIndirectable::indexOk(int i){
  return i < nextI;
}
/*
SuperIndirectable::SuperIndirectable(){
  val=0;
  SuperIndirectable::recordInstance(this);
}
SuperIndirectable::SuperIndirectable(float v){
  val=v;
  SuperIndirectable::recordInstance(this);
}

float SuperIndirectable::get() const { 
  return val;
}
float SuperIndirectable::set(float v){
  return val = v;
}
float SuperIndirectable::plusV(float v){
  return val += v;
}
float SuperIndirectable::minusV(float v){
  return val -= v;
}
float SuperIndirectable::multV(float v){
  return val *= v;    
}
float SuperIndirectable::divV(float v){
  return val /= v;    
}
*/
float SuperIndirectable::get(int index,float) { 
  #ifdef DEBUG
  Serial.println("SuperIndirectable::get(" + String(index) +")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->get()));
  #endif
  return SuperIndirectable::getInstance(index)->get();
}
float SuperIndirectable::set(int index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::set(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->set(v)));
  #endif
  return SuperIndirectable::getInstance(index)->set(v);
}
float SuperIndirectable::plusV(int index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::plusV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->plusV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->plusV(v);
}
float SuperIndirectable::minusV(int index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::minusV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->minusV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->minusV(v);
}
float SuperIndirectable::multV(int index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::multV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->multV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->multV(v);

}
float SuperIndirectable::divV(int index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::divV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->divV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->divV(v);
}


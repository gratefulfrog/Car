#include "SuperIndirectable.h"

SuperIndirectable *SuperIndirectable::iVec[SuperIndirectable::maxI];
byte SuperIndirectable::nextI = 0;

void SuperIndirectable::recordInstance(SuperIndirectable *instance){
  // add instane to vector, or fail quietly...
  if (SuperIndirectable::nextI< SuperIndirectable::maxI){
    SuperIndirectable::iVec[nextI++] =  instance;
  }
}

SuperIndirectable *SuperIndirectable::getInstance(byte index){
  // return index or NULL if failure
  if (index>=SuperIndirectable::nextI){
    return NULL;
  }
  else {
    return SuperIndirectable::iVec[index];
  }
}

void SuperIndirectable::showAll(){
  for(byte i=0;i<SuperIndirectable::nextI;i++){
    Serial.print(String(i) + " : ");
    Serial.println(iVec[i]->get());
  }
}

bool SuperIndirectable::indexOk(byte i){
  return i < nextI;
}

float SuperIndirectable::get(byte index,float) { 
  #ifdef DEBUG
  Serial.println("SuperIndirectable::get(" + String(index) +")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->get()));
  #endif
  return SuperIndirectable::getInstance(index)->get();
}
float SuperIndirectable::set(byte index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::set(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->set(v)));
  #endif
  return SuperIndirectable::getInstance(index)->set(v);
}
float SuperIndirectable::plusV(byte index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::plusV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->plusV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->plusV(v);
}
float SuperIndirectable::minusV(byte index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::minusV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->minusV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->minusV(v);
}
float SuperIndirectable::multV(byte index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::multV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->multV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->multV(v);

}
float SuperIndirectable::divV(byte index,float v){
  #ifdef DEBUG
  Serial.println("SuperIndirectable::divV(" + String(index) + "," + String(v) + ")");
  //Serial.println("return: " +  String(SuperIndirectable::getInstance(index)->divV(v)));
  #endif
  return SuperIndirectable::getInstance(index)->divV(v);
}


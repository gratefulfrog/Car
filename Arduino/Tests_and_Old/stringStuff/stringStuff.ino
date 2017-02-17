/* This provides some littl routines that will be used to cmummicate via Serial
 *  with our autonomous car.
 *  
 *  The idea is that all modifiable state member variables will be instances of the 
 *  Indirectable class allowing for their assignment/access in a protected manner from
 *  outside the instance which owns the state variable.
 *  
 *  Example:
 *  Class Car{
 *    public:
 *      Indirectable velocity                   = Indirectable(),
 *                   maxVelocity                = Indirectable(1000),  //mm par second
 *                   steeringAngle              = Indirectable(),
 *                   maxSteeringAngle           = Indirectable(radians(30)),  
 *                   steeringAngularVelocity    = Indirectable(),
 *                   maxSteeringAngularVelocity = Indirectable(radians(150)),  // radians par second
 *                   
 *                   pArarray[2][3] = {{Indirectable(kp[0]),
 *                                      Indirectable(ki[0]),
 *                                      Indirectable(kd[0])},
 *                                     {Indirectable(kp[1]),
 *                                      Indirectable(ki[1]),
 *                                      Indirectable(kd[1])};
 *      
 *  etc.
 */

  
#include "Indirectable.h"

String c2s(char *inBuf, byte len){
   char lBuf[len+1];
  for (int i =0;i<len;i++){
    lBuf[i] =  inBuf[i];
  }
  lBuf[len] = '\0';
  return String(lBuf);
}


float c2f(char *inBuf, byte len){
  return c2s(inBuf,len).toFloat();
}
int c2i(char *inBuf, byte len){
  return c2s(inBuf,len).toInt();
}


void setup() {

  char b1[] = {'1','2','.','3','4'},
       b2[] = {'1','0'};
  // put your setup code here, to run once:
  Serial.begin(115200);
  while(!Serial);
  //Serial.println(c2f(b1,5));
  //Serial.println(c2i(b2,2));

  
  Indirectable ida(10);
  Serial.println(ida.get());
  ida.timesV(2);
  Serial.println(ida.get());
  ida.addV(2);
  Serial.println(ida.get());
  ida.set(2);
  Serial.println(ida.get());
  
  Serial.println ("All");
  Indirectable::showAll();

  Indirectable idb(100);
  Serial.println(idb.get());
  idb.timesV(2);
  Serial.println(idb.get());
  idb.addV(20);
  Serial.println(idb.get());
  idb.set(20);
  Serial.println(idb.get());

  Serial.println ("All");
  Indirectable::showAll();
}

void loop() {
  // put your main code here, to run repeatedly:

}

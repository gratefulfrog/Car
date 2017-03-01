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

#include <Arduino.h>
#include "Spec.h"
#include "Car.h"

void setup(){
  Serial.begin(9600);
  while(!Serial);

  Serial.println("Starting up!");

  Spec spec =  Spec();
  Car car = Car(20,0.5,spec);

  Serial.print("car.angle.get(): ");
  Serial.println(car.angle.get());
  Serial.print("car.angularVelocity.get(): ");
  Serial.println(car.angularVelocity.get());
  
  Serial.print("car.angle.set(150): ");
  Serial.println(car.angle.set(150));
  Serial.print("car.angle.get(): ");
  Serial.println(car.angle.get());

  
  Serial.print("car.angle.set(10): ");
  Serial.println(car.angle.set(10));
  Serial.print("car.angle.get(): ");
  Serial.println(car.angle.get());

  Serial.print("car.angle.set(1000): ");
  Serial.println(car.angle.set(1000));
  Serial.print("car.angle.get(): ");
  Serial.println(car.angle.get());

}

void loop(){
  
}



/*
const int ledPin = 13;

const int nbIndirs = 5;

Indirectable *ind[nbIndirs];
Comms *c;





void setup() {
  pinMode(ledPin,OUTPUT);
  createInds(nbIndirs);
  c = new Comms();
  #ifdef DEBUG
    doTest();
   #endif
}

void loop() {
  c->stepLoop();
}

void createInds(int n){
  for (int i=0; i< n;i++){
    ind[i] = new Indirectable(10*i);
  }
}

#ifdef DEBUG
void doTest(){
  Serial.println ("\nid A");
  Indirectable ida(10);
  Serial.println(ida.get());
  
  ida.multV(2);
  Serial.println ("times 2");
  Serial.println(ida.get());
  
  ida.plusV(2);
  Serial.println ("plus 2");
  Serial.println(ida.get());
  
  ida.set(2);
  Serial.println ("set to 2");
  Serial.println(ida.get());
  
  Serial.println ("All");
  Indirectable::showAll();


  Serial.println ("\nid B");
  Indirectable idb(100);
  Serial.println(idb.get());

  idb.multV(2);
  Serial.println ("times 2");
  Serial.println(idb.get());

  idb.plusV(20);
  Serial.println ("plus 20");
  Serial.println(idb.get());
  
  idb.set(20);
  Serial.println ("set to 20");
  Serial.println(idb.get());

  Serial.println ("All");
  Indirectable::showAll();

  Serial.println ("\nid C");
  Indirectable idc(1000);
  Serial.println ("call to the instance");
  Serial.println(idc.get());
  
  Serial.println ("call via the class");
  Serial.println(Indirectable::get(2,0));
  
  Indirectable::multV(2,2);
  Serial.println ("times 2");
  Serial.println(Indirectable::get(2,0));
  
  Indirectable::plusV(2,20);
  Serial.println ("plus 20");
  Serial.println(Indirectable::get(2,0));

  Serial.println ("\nid D");
  Indirectable idd;
  
  Serial.println ("All");
  Indirectable::showAll();

  Serial.println("\n\n\n");
  char msg0[8] = {'s','0','0','1','.','0','0','0'};
  MessageMgr::processMessage(msg0);
  Serial.println("\n");

  char msg1[8] = {'g','0','1','1','.','0','0','0'};
  MessageMgr::processMessage(msg1);
  Serial.println("\n");
  
  char msg2[8] = {'t','0','2','2','.','0','0','0'};
  MessageMgr::processMessage(msg2);
  Serial.println("\n");

  char msg3[8] = {'p','0','3','2','2','2','.','2'};
  MessageMgr::processMessage(msg3);
  Serial.println("\n");

  char msg4[8] = {'m','0','3','0','0','0','1','2'};
  MessageMgr::processMessage(msg4);
  Serial.println("\n");

  char msg5[8] = {'d','0','0','0','0','0','1','0'};
  MessageMgr::processMessage(msg5);
  Serial.println("\n");

  Serial.println ("All");
  Indirectable::showAll();
}
#endif
*/

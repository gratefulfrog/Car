#include "app.h"

TestApp *app1, *app2;

void setup() {
  app1 = new TestApp();
  app2 = new TestApp();
  
  Serial.begin(115200);
  while(!Serial);
  
  Serial.println("App1");
  Serial.println(app1->id);
  Serial.println(app1->get(0));
  Serial.println(app1->get(1));
  Serial.println(app1->get(2));
  
  Serial.println("App2");
  Serial.println(app2->id);
  Serial.println(app2->get(0));
  Serial.println(app2->get(1));
  Serial.println(app2->get(2));

  app1->set(0,10.1);
  app1->set(1,20.2);
  app1->set(2,30.3);

  Serial.println("App1");
  Serial.println(app1->get(0));
  Serial.println(app1->get(1));
  Serial.println(app1->get(2));
  Serial.println("App2");
  Serial.println(app2->get(0));
  Serial.println(app2->get(1));
  Serial.println(app2->get(2));

  //Serial.println(Indirect::lastID);

}

void loop() {
  // put your main code here, to run repeatedly:

}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while(!Serial);
  int x = 2;

  Serial.println(x+=10);
  Serial.println(x);
  

}

void loop() {
  // put your main code here, to run repeatedly:

}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  String s(0.000094,5);
  Serial.println(s +" "+ String(s.length()));
  int l = s.length()-1;
  while (s.length()>5){
    s = String(s.toFloat(),l--);
  }
  Serial.println(s);

}

void loop() {
  // put your main code here, to run repeatedly:

}

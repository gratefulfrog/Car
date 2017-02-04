void setup(){
  size(1800,900);
  stroke(0);
  fill(0);
  background(255);
  translate(200,200);
  arc(0,0,500,500,-HALF_PI,0);
  rotate(radians(90));
  translate(0,-250);
  scale(1,-1);
  arc(0,0,500,500,-HALF_PI,0);

}
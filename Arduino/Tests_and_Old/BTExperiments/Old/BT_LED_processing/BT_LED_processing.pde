import processing.serial.*;

Serial bt;

int power = 0;

void setup(){
  size(300,100);
  background(0);
  
  String btPort = "/dev/rfcomm0";
  bt = new Serial(this, btPort, 9600);
}

void mousePressed(){
  background(0);
  if (mouseButton == RIGHT) {
    char c = char(byte(random(':','~')));
    text("sending an '"+ c + "'...",50,50);
    bt.write(c);
    return;
  }
  power ^= 1;
  text("Power: " + (power == 0 ? "off" : "on"), 50,50); 
  bt.write(power==1 ? '1' : '0');
}

void draw(){}
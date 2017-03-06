void mousePressed(){
  if (mouseY <= 100 && mouseX > 0 && mouseX < width/3)
    KetaiKeyboard.toggle(this);
  else if (mouseY <= 100 && mouseX > width/3 && mouseX < 2*(width/3)) //config button
    isConfiguring=true;
  else if (mouseY <= 100 && mouseX > 2*(width/3) && mouseX < width){ // draw button
    if (isConfiguring){
      background(78, 93, 75);
      isConfiguring=false;
    }
  }
  else{
    if (isConfiguring)
      return;
    OscMessage m = new OscMessage("/led");
    lastSent ^=1;
    m.add(lastSent);
    print("Sending: ");
    println(m.get(0).intValue());
    println(m.toString());
    //bt.broadcast(m.getBytes());
    sendSLIP(m.getBytes());
  }
}
// Serial & OSC Stuff
final int END = 0300;
final int ESC = 0333;
final int ESC_END = 0334;
final int ESC_ESC = 0335;  



// magical SLIP to Serial converter!
void sendSLIP(byte[] packet) { 
  //device.write(END);
  byte out[] = new byte[1];
  out[0]=(byte)END;
  bt.broadcast(out);
  for (int i=0; i<packet.length; i++) {
    switch (packet[i]) {
      case (byte)END:
      case (byte)ESC:
        //device.write(ESC);
        //device.write(ESC_END);
        out[0] = (byte)ESC;
        bt.broadcast(out);
        out[0] = (byte)ESC_END;
        bt.broadcast(out);
        break;
      //case (byte)ESC:
        //device.write(ESC);
        //device.write(ESC_END);
        //break;
      default:
        out[0] = packet[i];
        bt.broadcast(out);
        //device.write(packet[i]);
        //println(packet[i]);        
    }
  }
  out[0]=(byte)END;
  bt.broadcast(out);
  
  //device.write(END);
}

void keyPressed() {
  if (key =='c'){
    //If we have not discovered any devices, try prior paired devices
    if (bt.getDiscoveredDeviceNames().size() > 0)
      connectionList = new KetaiList(this, bt.getDiscoveredDeviceNames());
    else if (bt.getPairedDeviceNames().size() > 0)
      connectionList = new KetaiList(this, bt.getPairedDeviceNames());
  }
  else if (key == 'd')
    bt.discoverDevices();
  else if (key == 'b')
    bt.makeDiscoverable();
}

void drawUI(){
  pushStyle();
  fill(0);
  stroke(255);
  rect(0, 0, width/3, 100);
  
  if (isConfiguring){
    noStroke();
    fill(78, 93, 75);
  }
  else
    fill(0);
    
  rect(width/3, 0, width/3, 100);
  if (!isConfiguring){
    noStroke();
    fill(78, 93, 75);
  }
  else {
  fill(0);
  stroke(255);
  }
  rect((width/3)*2, 0, width/3, 100);
  fill(255);
  text("Keyboard", 5, 70);
  text("Bluetooth", width/3+5, 70);
  text("Interact", width/3*2+5, 70);
  popStyle();
}

void onKetaiListSelection(KetaiList connectionList) {
  String selection = connectionList.getSelection();
  bt.connectToDeviceByName(selection);
  connectionList = null;
}  
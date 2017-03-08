// Serial & OSC Stuff
final int END = 0300;
final int ESC = 0333;
final int ESC_END = 0334;
final int ESC_ESC = 0335;  

int nbBytes2Send(byte[] packet) { 
  int res = 2;
  for (int i=0; i<packet.length; i++) {
    switch (packet[i]) {
      case (byte)END:
      case (byte)ESC:
        res+=2;
        break;
      default:
        res++;
        break;
    }
  }
  return res;
}


// magical SLIP to Serial converter!
void sendSLIP(byte[] packet) { 
  //device.write(END);
  byte outgoing[] = new byte[nbBytes2Send(packet)];
  int oInd =0;
  outgoing[oInd++]=(byte)END;
  for (int i=0; i<packet.length; i++) {
    switch (packet[i]) {
      case (byte)END:
        outgoing[oInd++] = (byte)ESC;
        outgoing[oInd++] = (byte)ESC_END;
        break;
      case (byte)ESC:
        outgoing[oInd++] = (byte)ESC;
        outgoing[oInd++] = (byte)ESC_ESC;
        break;
      default:
        outgoing[oInd++] = packet[i];
        break;
    }
  }
  outgoing[oInd++]=(byte)END;
  bt.broadcast(outgoing);
}

void sendSpeedAndAngleViaOsc(float speed, float angle){
  OscMessage m = new OscMessage("/led");
  m.add(speed);
  m.add(angle);  
  print("Sending: ");
  println(m.get(0).floatValue());
  println(m.get(1).floatValue());
  println(m.toString());
  sendSLIP(m.getBytes());
  println("Sent: " , nbBytes2Send(m.getBytes()), " bytes");
}


void sendIntViaOsc(int val){
  OscMessage m = new OscMessage("/led");
  m.add(val);
  print("Sending: ");
  println(m.get(0).intValue());
  println(m.toString());
  sendSLIP(m.getBytes());
  println("Sent: " , nbBytes2Send(m.getBytes()), " bytes");
}
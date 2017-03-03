class App{
  String outgoing = "",
         lastSent = "";
  final int outMsgLen = 8,
            connectedFrameLimit = 100,
            vibTime = 300;
  
  int connectedFrameCount =0;      
  boolean disconnectFlag = false,
          inputError = false;
      
  BTManager btm;
  PApplet applet;
  KetaiVibrate vib;
  
  
  App(String device, KetaiBluetooth kbt,PApplet aplt){
    btm = new BTManager(device,kbt);
    applet = aplt;
    vib = new KetaiVibrate(applet);
  }  
  void draw(){
    background(bg);
    if(disconnectFlag){
      btm.doBtConnect();
      //println("reconnected!");
      connectedFrameCount = connectedFrameLimit;
    }
    disconnectFlag = !btm.areWeConnected();
    if(!disconnectFlag){
      normalUI();
    }
    else {
      reconnectUI();
    }
  }
 
  void reconnectUI(){
    KetaiKeyboard.hide(applet);
    text("Conenection Lost!  Reconnecting...",width/2.0,height/2.0);
    //println("conenection lost!!! reconnecting...");
  }
  void normalUI(){  
    if(connectedFrameCount ==0){
      KetaiKeyboard.show(applet);  //KetaiKeyboard.toggle(this);
      text("Sending: " + outgoing,width/2,textS);
      text(outMsgLen - outgoing.length() + " Chars Remaining",width/2,textS*2);
      text("Sent: " + lastSent,width/2,textS*4);
      text("Received: " + incoming,width/2,5*textS);
      text("Message 'cNNddddd'; 'ENTER' to send;\nk to Kancel;\n'q' to quit",width/2,7*textS);
      if (inputError){
        //text("I said, '8 chars, 'q' or ENTER'! Pay Attention!",width/2,5*textS);
        vib.vibrate(vibTime);
        inputError = false;
      }
    }
    else{
      text("Reconnected!",width/2.0,height/2.0);
      connectedFrameCount--;
    }
  }
  
  void keyPressed(){
    if ((key >='0' && key <= '9' ) ||
        (key == 'd')               ||
        (key == 'g')               ||
        (key == 'm')               ||
        (key == 'p')               ||
        (key == 's')               ||
        (key == 't')               ||
        (key == 'x')               ||
        (key == '.')){
      outgoing += key;  
      inputError = false;
    }
    else if (key == 'k'){  // cancel current outgong
      outgoing="";
      inputError = true;
    }
    else if (keyCode == android.view.KeyEvent.KEYCODE_ENTER){
      if (outgoing.length() % outMsgLen == 0) {
        btm.send(outgoing);
        lastSent = outgoing;
        outgoing = "";
        inputError=false;
      }
      else{
        inputError = true;
        return;
      }  
    }
    else if (key == 'q'){
      inputError=false;
      btm.bt.stop();
      System.exit(0);
    }
    else  {
      inputError=true;
      return;
    }
  }
}
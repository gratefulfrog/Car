class App{
  String outgoing = "";
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
    text("conenection lost!!! reconnecting...",width/2.0,height/2.0);
    //println("conenection lost!!! reconnecting...");
  }
  void normalUI(){  
    if(connectedFrameCount ==0){
      KetaiKeyboard.show(applet);  //KetaiKeyboard.toggle(this);
      text("Sent: " + outgoing,width/2,textS);
      text("Received: " + incoming,width/2,2*textS);
      text("Message of the form 'cNNddddd' or 'ENTER' to send; or 'q' to quit",width/2,4*textS);
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
        (key == 'g')               ||
        (key == 'p')               ||
        (key == 's')               ||
        (key == 't')               ||
        (key == 'x')               ||
        (key == '.')){
      outgoing += key;  
      inputError = false;
    }
    else if (keyCode == android.view.KeyEvent.KEYCODE_ENTER){
      if (outgoing.length() % outMsgLen == 0) {
        btm.send(outgoing);
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
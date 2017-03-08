class App{
  String outgoing = "",
         lastSent = "";
  final int connectedFrameLimit = 100;
  
  int connectedFrameCount =0;      
  boolean disconnectFlag = false;
  final int textS= 36,
          bg = 130;
          
  BTManager btm;
  PApplet applet;  
  
  App(String device, KetaiBluetooth kbt,PApplet aplt){
    btm = new BTManager(device,kbt);
    applet = aplt;
  }  
  void draw(){
    pushStyle();
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
    popStyle();
  }
 
  void reconnectUI(){
    KetaiKeyboard.hide(applet);
    text("Conenection Lost!  Reconnecting...",width/2.0,height/2.0);
    //println("conenection lost!!! reconnecting...");
  }
  void normalUI(){  
    if(connectedFrameCount ==0){
      return;
    }
    else{
      text("Reconnected!",width/2.0,height/2.0);
      connectedFrameCount--;
    }
  }
}
class Comms{
  final int inLimit= 8;
  char incoming[inLimit];
  int nbIn;

  Comms(){
    Comms::Comms(){
    Serial.begin(115200);
    while(!Serial);
    nbIn=0;
  }
  
  boolean addChar(char c);
    
  public:
    
    void stepLoop();
    void setLed();
    static void send(char*);
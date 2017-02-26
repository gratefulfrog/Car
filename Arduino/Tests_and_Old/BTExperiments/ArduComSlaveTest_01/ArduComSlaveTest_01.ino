/* This is an example of how to use the ArduComSlave class.
 * First we have to define a function that will generate the response to incoming messages
 * 'prcoMsg' is just that: It prepends alternatively an 'e' or an 'x' to the incoming message
 * Then we declare a pointer to an ArduComSlave, 
 * we instatiate the ArduComSlave, then call its doInit method. Upon exit from that, it is ready to go.
 * Note that we have used 'Serial' as the serial object port.
 * in the loop(), we only have to call stepLoop() and the rest is magic.
 * test this by inputing at the Serial Monitor:
 * first type an 'A' to confirm init,
 * then type sequences of 5 chars and observing the responses.
 */

#include "ArduCom.h"

ArduComSlave *com;

boolean ok = false;

boolean procMsg(char *buf,char*, int bufSize){
  // just for creating errors,
  // this is an 'ArduComResponseFunc'
  static boolean lastResponseTrue = false;
  if (lastResponseTrue){
    buf[0] =  'e';
  }
  else{
    buf[0] =  'x';
  }
  lastResponseTrue = !lastResponseTrue;
  ok=true;
  return !lastResponseTrue;
}

int c2i(char*c, int n){
  char res[n+1];
  for (int i=0;i<n;i++){
    res[i] = c[i];
  }
  res[n] = '\0';
  return (int (res));
}

float c2f(char*c, int n){
  char res[n+1];
  for (int i=0;i<n;i++){
    res[i] = c[i];
  }
  res[n] = '\0';
  return (atof (res));
}

void doSet(char *buf){
  int x = 1;//ok=true;
}
/*
  int oID = c2i(buf+1,2),
      fID = c2i(buf+3,2);
  float f = c2f(buf+5,6);
  ok = true;
  for (int i=0;i<ARDUCOM_MSGSIZE;i++){
    buf[i]='j';
   
  }
  //com->msg(String(oID) + String(fID) + String(f), NULL, 0);
}
*/
void doGet(char*buf){}
void doX(char*buf){}

char c;


boolean procMsgProtocl(char *buf,char*, int bufSize){
  // this is an 'ArduComResponseFunc'
  switch(buf[0]){
    case 's':
    case 'S':
      doSet(buf);
      break;
    case 'g':
    case 'G':
      doGet(buf);
      break;
    case 'x':
    case 'X':
      doX(buf);
      break;
    default:
      ok=true;
      break;
      //com->msg(String(buf[0]),NULL,0);
  }
  c= buf[0];
  ok=true;
  return true;
}

  


//////////////  std functions ////////////////

void setup(){
  //com = new ArduComSlave(&Serial,&procMsg,ARDUCOM_MSGSIZE);
  com = new ArduComSlave(&Serial,&procMsgProtocl,ARDUCOM_MSGSIZE);
  com->doInit();
}

void loop(){
  com->stepLoop();
  if (ok){
    com->msg("",&c,0);
    ok=false;
  }
}


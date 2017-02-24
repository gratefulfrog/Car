#include "MessageMgr.h"

const byte MessageMgr::inMsgLen  = 8,
           MessageMgr::outMsgLen = inMsgLen+1,
           MessageMgr::nbRFuncs  = 5,
           MessageMgr::charCharLen = 1,
           MessageMgr::intCharLen = 2,
           MessageMgr::floatCharLen = 5;

const char MessageMgr::rFuncIndexVec[] = {'g','s', 'p', 't', 'x'};
const rFuncPtr MessageMgr::rFuncVec[] = { &Indirectable::get,
                                       &Indirectable::set,
                                       &Indirectable::addV,
                                       &Indirectable::timesV};
                                   
bool MessageMgr::syntaxOK(char* msg){
  // 1. is the first letter a character?
  bool res = isAlpha(msg[0]);
  
  // 2. are the next 2 chars digits?
  if (res){
    // so the function indicator is ok, now looke at the variable index
    res = res && isDigit(msg[1]) && isDigit(msg[2]);
  }
  
  // then we got 2 digits, now look at the float
  bool curRes = true; 
  if (res){  
    bool decimalFound = false;
    for (byte i=0;(i< floatCharLen && curRes);i++){
      char c = msg[charCharLen+intCharLen+ i];
      if(!decimalFound){
        decimalFound = ('.' == c);
        curRes = decimalFound ? true : isDigit(c);
      }
      // decimal point has been found
      else {
        // decimal found 
        curRes = isDigit(c);
      }
    }
  }
  res =  res && curRes;
  
  return res;
}

bool MessageMgr::semanticsOK(char* msg){
  // syntax is already checked
  bool res = false;
  for (byte i=0;(i<nbRFuncs && !res);i++){
   res = msg[0] == rFuncIndexVec[i];
  }
  // We checked the indicator, now is the value of the var index ok?
  res =  res && Indirectable::indexOk(c2i(msg + charCharLen, intCharLen));
  
  // we already know that the float was ok syntactically so we are good to go
  return res;
}
    
rFuncPtr MessageMgr::indirectableFunc(char* msg){
  rFuncPtr res = NULL;
  for (byte i=0;i<nbRFuncs;i++){
    if (msg[0] == rFuncIndexVec[i]){
      res = rFuncVec[i];
      break;
    }
  }
  return res;
}
int MessageMgr::arg0(char *msg){
  return c2i(msg+charCharLen,intCharLen);
}
float MessageMgr::arg1(char *msg){
  return c2f(msg+charCharLen+intCharLen,floatCharLen);
}

char* MessageMgr::formatResponse(char* msg, float v){
  static char response[outMsgLen];
  response[0] = 'G';
  for (byte i=0;i<charCharLen+intCharLen;i++){
    response[i+charCharLen] = msg[i];
  }
  String s(v,5);
  int l = s.length()-1;
  while (s.length()>5){
    s = String(s.toFloat(),l--);
  }
  for (byte i=0;i<floatCharLen;i++){
    response[i+1+charCharLen+intCharLen] = s.charAt(i);
  }
  return response;
}

char*  MessageMgr::formatErrorResponse(char* msg){
  static char response[outMsgLen];
  response[0] = 'E';
  for (byte i=0;i<inMsgLen;i++){
   response[i+charCharLen]=msg[i];
  }
  return response;
}

String MessageMgr::c2s(char *inBuf, byte len){
  char lBuf[len+1];
  for (int i =0;i<len;i++){
    lBuf[i] =  inBuf[i];
  }
  lBuf[len] = '\0';
  return String(lBuf);
}

float MessageMgr::c2f(char *inBuf, byte len){
  return c2s(inBuf,len).toFloat();
}
int MessageMgr::c2i(char *inBuf, byte len){
  return c2s(inBuf,len).toInt();
}


// put this function definition in the cpp file.!!
void MessageMgr::processMessage(char* msg){
  if (syntaxOK(msg) && semanticsOK(msg)){
    Comms::send(formatResponse(msg,((*indirectableFunc(msg))(arg0(msg),arg1(msg)))));
  }
  else {
    Comms::send(formatErrorResponse(msg));
  }
}


#ifndef MESSAGE_MGR_H
#define MESSAGE_MGR_H

#include "Comms.h"

/*  Process incoming messages in coordination with Indirectables and Comms
 *   void MessageMgr::processMessage(char* msg){
 *     if (syntaxOK(msg) && semanticsOK(msg)){
 *        comms.send(formatResponse(msg,((*indirectableFunc(msg))(arg0(msg),arg1(msg)))));
 *     }
 *     else {
 *       coms.send(formatErrorResponse(msg));
 *     }
 *   The goal is: 
 *   1. take an incoming char[MSG_IN_SIZE], call it 'msg'
 *   2. if it is syntactically ok and semantically ok, then
 *   2.1  send((*formatResponse(msg))((*indirectableFunc(msg))(arg0(msg),arg1(msg))))
 *        which looks like this in more detail:
 *        let: 
 *          // a pointer to a function which will properly format the output from the processing of the msg
 *          responseFuncPtr          = formatResponse(msg)
 *          
 *          // a pointer to a function which should be called on the arguments extracted from the message
 *          indirectableFuncPtr      = indirectableFunc(msg)
 *          
 *          // first argument extracted from the msg
 *          arg0                     = arg0(msg)
 *          
 *          // second argument extracted from the msg
 *          arg1                     = arg1(msg)
 *          
 *          // here we have the result of dereferencing the pointer to the indirectable func, applied to args
 *          resultOfIndirectableCall =  (*indirectableFuncPtr)(arg0,arg1)
 *          
 *          // and here the result of the application of derefencing the response func ptr to the result of the idirectableFuncPtr call
 *          outgoingMessage          = (*responseFuncPtr)(resultOfIndirectableCall)
 *        
 *        then:
 *          // we send the outgoing message via send from comms
 *          send(outgoingMessage)
 *          
 *    3. else -- msg is not correct
 *    
 *        // use same technique to compute the proper response, based on the msg and send it via comms even cooler!
 *    3.1 send ((*(*formatErrorResponse)(msg))(msg))
 *        let 
 *           // first we need to get a function that will properly format the error response, based on the msg
 *           formattingFuncPtr =  (*formatErrorRepsonse)(msg)
 *           
 *           // then we need to apply it to the message to get the error message to send as the reply
 *           outgoingErrorMsg  = (*formattingFuncPtr)(msg)
 *           
 *           // and finally send it
 *           send(outgoingErrorMsg)
 *   
 *   SUPER ELEGANT, n'est-ce pas?
 */

#include "Indirectable.h"

class MessageMgr{

  protected:
    //class member variables
    // lengths in nb of characters
    static const byte inMsgLen,
                      outMsgLen,
                      nbRFuncs,
                      charCharLen,
                      intCharLen,
                      floatCharLen;
                      
    static const char rFuncIndexVec[]; 
    static const rFuncPtr rFuncVec[];

    // class static methods
    static bool syntaxOK(char*);
    static bool semanticsOK(char*);
    
    static rFuncPtr indirectableFunc(char*);
    static int      arg0(char *msg);
    static float    arg1(char *msg);
    static char*    formatResponse(char*,float);
    static char*    formatErrorResponse(char*);
         
    static String c2s(char *inBuf, byte len);
    static float c2f(char *inBuf, byte len);
    static int c2i(char *inBuf, byte len);
    
  public:
    static void processMessage(char* msg);    
};


#endif

/*
 *  OSC.cpp
 *  OSCMinuitSender
 *
 *  Created by vernier on 18/05/09.
 *  Copyright 2009 University of Paris 11. All rights reserved.
 *
 */

#include "OSC.h"

#include <iostream>
#include <string.h>
#include <CoreFoundation/CoreFoundation.h>

#include "osc/OscOutboundPacketStream.h"
#include "osc/OscPacketListener.h"
#include "osc/OscTypes.h"

#include "ip/IpEndpointName.h"
#include "ip/UdpSocket.h"

char buffer[1024];
//UdpTransmitSocket *transmitSocket = NULL;
UdpListeningReceiveSocket *listenSocket   = NULL;
osc::OutboundPacketStream *ops    = NULL;
int counter;




//  SENDER //
void startOSCMsg(){
  // formatting messages into a packet for sending:
  ops = new osc::OutboundPacketStream( buffer, 1024 );
  *ops << osc::BeginBundleImmediate;
}

void addStringToOSCMsg(const char *name, const char *txt){    
  *ops << osc::BeginMessage( name ) << txt << osc::EndMessage;
}

void addFloatToOSCMsg(const char *name, float value){        
  *ops << osc::BeginMessage( name ) << value << osc::EndMessage;
}    

int finishOSCMsg(int ip1, int ip2, int ip3, int ip4, int port){        
  *ops << osc::EndBundle;
  
  char* address = (char *)malloc(32*sizeof(char));
  //printf("send val to %s on port %i \n", address, port);
  
  sprintf(address, "%d.%d.%d.%d", ip1, ip2, ip3, ip4);
  UdpSocket socket;
  IpEndpointName ien = IpEndpointName(address, port);
  socket.Connect(ien);
  //printf("  is sender bound ? %i %i\n", socket.IsBound(), socket.IsConnected());
  socket.Send( ops->Data(), ops->Size() );
  //printf("  is sender bound ? %i %i\n", socket.IsBound(), socket.IsConnected());
  free(address);
  free(ops);
  ops = NULL;
  return 0;
}


// RECEIVER //
class MinuitPacketListener : public osc::OscPacketListener {
  private :
  OSCMinuitReceiverPlugIn* callbacker;
  public:
  MinuitPacketListener(OSCMinuitReceiverPlugIn* _callbacker){
    callbacker = _callbacker;
  }
  protected:
  virtual void ProcessMessage( const osc::ReceivedMessage& m, const IpEndpointName& remoteEndpoint ){
    try{
      const char *names = m.TypeTags();
      osc::ReceivedMessage::const_iterator arg = m.ArgumentsBegin();
      //namespace answer
      //NSLog(@"       receive %s from  %x, %d",m.AddressPattern(), remoteEndpoint.address, remoteEndpoint.port);
      if (strcmp( m.AddressPattern(), "?namespace" ) == 0 && m.ArgumentCount()==1 && names[0] == osc::STRING_TYPE_TAG){
        //NSLog(@"       receive namespace query !!! %x, %d", remoteEndpoint.address, remoteEndpoint.port);
        const char *a0 = (arg++)->AsString();
        NSMutableDictionary* nns = [callbacker getNameSpaceForPrefix:[[NSString alloc] initWithCString:a0]];
        char listN[1024]=""; //nodes
        char listL[1024]=""; //leaves
        char list[1024]=""; //leaves
        
		    memset(listN, 0, 1024);
		    memset(listL, 0, 1024);
		    memset(list, 0, 1024);
        
        int nbNodes = 0;
        int nbLeaves = 0;
        
        if(nns!=nil && [nns count]>0){
          strcpy (listN, "nodes={");
          strcpy (listL, "leaves={");
          for (NSString *name in nns){
            //InputDescriptor *desc = [nns valueForKey:name];
            
            if ([[[nns valueForKey:name] class] isSubclassOfClass:[InputDescriptor class]]){
              strcat (listL, [name cStringUsingEncoding:NSASCIIStringEncoding]);
              strcat (listL," ");
              nbLeaves++;
            } else {
              strcat (listN, [name cStringUsingEncoding:NSASCIIStringEncoding]);
              strcat (listN," ");
              nbNodes++;
            }
          }
          if(nbNodes>0)
            listN[strlen(listN)-1]= '}';
          if(nbLeaves>0)
            listL[strlen(listL)-1]= '}';  
        } else 
          strcpy (list, "ERROR");
        //NSLog(@"on envoie (%i+%i)\n", nbNodes, nbLeaves);
        if (nbNodes==0 && nbLeaves==0){
          //const char *a1 = (arg++)->AsString();
          //printf("receiving ?get : %s\n", a1);
          listenSocket->Connect(remoteEndpoint);
          char buffer3[1024];
          memset(buffer3, 0, 1024);
          osc::OutboundPacketStream ops3( buffer3, 1024 );
          
          NSMutableDictionary* leaveInfo = [callbacker getInfoForLeave:[[NSString alloc] initWithCString:a0]];
          NSString *stype = [leaveInfo valueForKey:@"type"];
          if ([stype compare:@"String"]==NSOrderedSame){
            NSString *val = [leaveInfo valueForKey:@"value"];
            //NSLog(@"//////////////////");
            //NSLog(@"type : %s", [stype cStringUsingEncoding:NSASCIIStringEncoding]);
            //NSLog(@"valeur : %s", [val cStringUsingEncoding:NSASCIIStringEncoding]);
            //NSLog(@"//////////////////");
            
            ops3 <<  osc::BeginMessage(":namespace") << a0 << "value" << [val cStringUsingEncoding:NSASCIIStringEncoding] << "type" << "s" << osc::EndMessage;
          } 
          else if ([stype compare:@"Float"]==NSOrderedSame){
            NSNumber *val= [leaveInfo valueForKey:@"value"];
            //NSLog(@"//////////////////");
            //NSLog(@"type : %s", [stype cStringUsingEncoding:NSASCIIStringEncoding]);
            //NSLog(@"valeur : %f", [val floatValue]);
            //NSLog(@"//////////////////");    
        
            ops3 <<  osc::BeginMessage(":namespace") << a0 << "value" <<  [val floatValue] << "type" << "f" << osc::EndMessage;
          } 
          listenSocket->Send( ops3.Data(), ops3.Size() );
          listenSocket->Unconnect();
          //xxx
          if( arg != m.ArgumentsEnd() )
            throw osc::ExcessArgumentException();
        } else {
          // prepare answer
          listenSocket->Connect(remoteEndpoint);
          char buffer3[1024];
          memset(buffer3, 0, 1024);
          osc::OutboundPacketStream ops3( buffer3, 1024 );
          
          // nodes, leaves or both
          if(nbNodes>0 && nbLeaves==0){
            ops3 <<  osc::BeginMessage(":namespace") << a0 << listN << osc::EndMessage;
          } else if(nbNodes==0 && nbLeaves>0)
            ops3 <<  osc::BeginMessage(":namespace") << a0 << listL << osc::EndMessage;
          else if(nbNodes>0 && nbLeaves>0){
            ops3 <<  osc::BeginMessage(":namespace") << a0 << listN << listL << osc::EndMessage;
          }
          
          //std::cout << "asked: |" << a0 << "| => " << nbNodes << "+" << nbLeaves << "\n";
          //sending
          //printf("liste en entier : %s", ops3.Data());
          
          listenSocket->Send( ops3.Data(), ops3.Size() );
          listenSocket->Unconnect();
          if( arg != m.ArgumentsEnd() )
            throw osc::ExcessArgumentException();
        }
      }
      else if (m.ArgumentCount()==1 && names[0] == osc::FLOAT_TYPE_TAG){
        //NSLog(@"receive float for ! %s", m.AddressPattern());
        float a3 = (arg++)->AsFloat();
        [callbacker updateValue:[[NSNumber alloc] initWithFloat:a3] forName:[[NSString alloc] initWithCString:m.AddressPattern()]];
        if( arg != m.ArgumentsEnd() )
          throw osc::ExcessArgumentException();
        //NSLog(@"DONE");
      } 
      else if (m.ArgumentCount()==1 && names[0] == osc::STRING_TYPE_TAG){
        const char *a2 = (arg++)->AsString();
        [callbacker updateValue:[[NSString alloc] initWithCString:a2] forName:[[NSString alloc] initWithCString:m.AddressPattern()]];
        if( arg != m.ArgumentsEnd() )
          throw osc::ExcessArgumentException();
      } 
      else {
        NSLog(@"receive unknown query ! %s", m.AddressPattern());
      }
      
    }catch( osc::Exception& e ){
      // any parsing errors such as unexpected argument types, or 
      // missing arguments get thrown as exceptions.
      std::cout << "error while parsing message: "
      << m.AddressPattern() << ": " << e.what() << "\n";
    }
  }
};    

void openInputSocket(int port, OSCMinuitReceiverPlugIn *callbacker){
  NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
  //std::cout << "openInputSocket...\n";
  MinuitPacketListener *listener = new MinuitPacketListener(callbacker);
  try {
    listenSocket = new UdpListeningReceiveSocket(IpEndpointName(IpEndpointName::ANY_ADDRESS, port), listener);
  }catch( osc::Exception& e ){
    std::cout << "error with ip opening socket\n";
  }
  
  //std::cout << "...before run\n";
  try {
    listenSocket->Run(); 
  }catch( osc::Exception& e ){
    std::cout << "error with osc on ip \n";
  }
  std::cout << ("...finished OSC listening thread\n");
  delete(listenSocket);
  free(listenSocket);
  free(listener);
  listenSocket=nil;
  listener = nil;
  [autoreleasepool release];
}    

void closeInputSocket(){
  listenSocket->AsynchronousBreak();
}    







// NAMESPACE RETRIEVER
void getOSCAttributes(const char*address, int port, const char *path, NSMutableDictionary *res){
  UdpSocket sock;
  
  IpEndpointName ien = IpEndpointName(address, port);
  IpEndpointName local = IpEndpointName(address, IpEndpointName::ANY_PORT);
  // because later we will wait for an answer
  sock.Bind(local);
  // connect the remote computer to ask its namespace
  sock.Connect(ien);
  
  char buffer2[1024];
  osc::OutboundPacketStream *ops2 = new osc::OutboundPacketStream( buffer2, 1024 );
  try {  
    *ops2 <<  osc::BeginMessage( "?namespace" ) << path << osc::EndMessage;
    //printf("sending  %s \n",  ops2->Data());fflush(stdout);
    sock.Send( ops2->Data(), ops2->Size() );
    
    if(!sock.IsBound())
      return;
    sock.ReceiveFrom(local, buffer2, 1024);
	  
    //printf("received final for %s \n", path);fflush(stdout);
    osc::ReceivedPacket packet(buffer2, 1024);
    osc::ReceivedMessage msg(packet);
    osc::ReceivedMessage::const_iterator arg = msg.ArgumentsBegin();
    
    if (strcmp( msg.AddressPattern(), ":namespace" ) == 0){
      const char *kkey = (arg++)->AsString();
      //printf("%s as 1rst arg\n", kkey);fflush(stdout);
      NSString *key0 = [NSString stringWithCString:kkey];
      const char *vvalue = (arg++)->AsString();
      //printf("%s as 2nd arg\n", vvalue);fflush(stdout);
      
      NSObject *vval = nil;
      if (arg->IsFloat())  
        vval = [[NSNumber alloc] initWithFloat:arg->AsFloat()];
      else if (arg->IsString())  
        vval = [NSString stringWithCString:arg->AsString()];
      
      //NSLog(@"arg : %@ = %@ \n", key0, vval);
      arg++;
      arg++;
      const char *ttype = (arg++)->AsString();
      NSString *type0 = [NSString stringWithCString:ttype];
      
      [res setObject:vval forKey:@"value"];
      [res setObject:key0 forKey:@"name"];
      [res setObject:type0 forKey:@"type"];
      if(arg != msg.ArgumentsEnd()){
        std::cout << "ERROR: :get message too long\n";
      }
    }    
  }
  catch( osc::Exception& e ){
    std::cout << "ERROR: Error with osc sending attributes request:" << e.what() << "\n";
  }
  free(ops2);
}


void re_getOSCNameSpace(const char*address, int port, const char *path, NSMutableDictionary *ns){
  //printf ("re_getOSCNameSpace %s\n", path);
  
  UdpSocket sock;
  
  IpEndpointName ien = IpEndpointName(address, port);
  IpEndpointName local = IpEndpointName(address, IpEndpointName::ANY_PORT);
  // because later we will wait for an answer
  sock.Bind(local);
  // connect the remote computer to ask its namespace
  sock.Connect(ien);
  
  char buffer1[1024];
  char buffer2[1024];
  memset(buffer1, 0, 1024);
  memset(buffer2, 0, 1024);
  osc::OutboundPacketStream *ops1 = new osc::OutboundPacketStream( buffer1, 1024 );
  try {  
    *ops1 <<  osc::BeginMessage( "?namespace" ) << path << osc::EndMessage;
    //printf("sending global ?namespace for %s \n",  path);
	  sock.Send( ops1->Data(), ops1->Size() );
    
    if(!sock.IsBound()) {
      printf("RROR: Can't get namespace because socjet not bound\n");fflush(stdout);
      return;
    }
    sock.ReceiveFrom(local, buffer2, 1024);
	  
    //printf("received global for %s \n", path);
    osc::ReceivedPacket packet(buffer2, 1024);
    osc::ReceivedMessage msg(packet);
    osc::ReceivedMessage::const_iterator arg = msg.ArgumentsBegin();
    
    if (strcmp( msg.AddressPattern(), ":namespace" ) == 0 && msg.ArgumentCount() >= 2){
      arg++; // skip what I asked
      const char *answer = (arg++)->AsString();
      
      if (strlen(answer) > 8 && strncmp(answer, "nodes={", 7) == 0 && strncmp(answer+strlen(answer)-1, "}", 1) == 0){
        char answer_copy[1024];
        //printf ("I receive first |%s|\n", answer);
        
        const char* oldpos = answer + 6;
        char* pos = strchr(answer, ' ');
        while (pos!=NULL){
          strcpy(answer_copy, path);
          if (answer_copy[strlen(answer_copy)-1]!='/')
            strcat(answer_copy, "/");
          strncat(answer_copy, oldpos+1, (pos-oldpos-1));
          re_getOSCNameSpace(address, port, answer_copy, ns);
          oldpos = pos;
          pos = strchr(pos+1, ' ');
        }
        strcpy(answer_copy,path);
        if (answer_copy[strlen(answer_copy)-1]!='/')
          strcat(answer_copy, "/");
        strncat(answer_copy, oldpos+1, strlen(oldpos)-2);
        re_getOSCNameSpace(address, port, answer_copy, ns);
        
        // move to the next part of the message to see if there are leaves too
        if (msg.ArgumentCount()>=2)
          answer =(arg++)->AsString();
      }// nodes
      
      // there are also leaves
      if (strlen(answer)>9 && strncmp(answer, "leaves={", 8)==0 && strncmp(answer+strlen(answer)-1, "}", 1)==0) {
        char answer_copy[1024];		  
        strncpy(answer_copy, answer+8, strlen(answer)-9);
		    answer_copy[strlen(answer)-9] = 0;
        
        char * pch;
        pch = strtok (answer_copy ," ");
        while (pch != NULL) {
          char str[128];
          strcpy(str, path);
          if (str[strlen(str)-1]!='/')
            strcat(str, "/");
          strcat(str, pch);
          //printf ("I know a remote path |%s|\n", str);          
          NSMutableDictionary *infos = [[NSMutableDictionary alloc] init];
          NSString *name = [[NSString alloc] initWithCString:str];
	        getOSCAttributes(address, port, str, infos);
          
          NSDictionary *descr = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name", [infos valueForKey:@"type"], @"type", [infos valueForKey:@"value"], @"value", nil];
          [ns setValue:descr forKey:[[NSNumber alloc] initWithInt:counter++]];
          pch = strtok (NULL, " ,.-");
        }
      } 
    } else {
      printf(" ERROR RCV: Don't understand %s with %d arguments\n",  msg.AddressPattern(), msg.ArgumentCount());
      osc::ReceivedPacket packet(buffer2, 1024);
      osc::ReceivedMessage msg(packet);
      osc::ReceivedMessage::const_iterator arg = msg.ArgumentsBegin();
      if (arg->IsString())
        printf(" arg = \n",  arg->AsString());
    }
  }catch( osc::Exception& e ){
    std::cout << "ERROR: Error with osc sending namespace request:" << e.what() << "\n"; 
    sleep(1);
    re_getOSCNameSpace(address, port, path, ns);
  }
  
  free(ops1);
  try {
    sock.Unconnect();
    //sock.Connect(IpEndpointName(address, 0));
  } catch( osc::Exception  e ){
    std::cout << "ERROR: Error with osc closin socket:" << e.what() << "\n";
  }
}// re_getOSCNameSpace()


void getOSCNameSpace(int ip1, int ip2, int ip3, int ip4, int port, NSMutableDictionary *ns){
  char address[32];
  sprintf(address, "%d.%d.%d.%d", ip1, ip2, ip3, ip4);
  counter = 0;

  printf("send namespace to %s on port %i \n", address, port);

  //printf("  is namespace retriever bound ? %i %i\n", sock.IsBound(), sock.IsConnected());
  // recursively
  re_getOSCNameSpace(address, port, "/", ns);

}// getOSCNameSpace()


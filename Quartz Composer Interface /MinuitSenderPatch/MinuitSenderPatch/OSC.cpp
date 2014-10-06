/*
 *  OSC.cpp
 *  MinuitSenderPatch
 *
 *  Created by vernier on 14/05/09.
 *  Copyright 2009 University of Paris 11. All rights reserved.
 *
 */

#include "OSC.h"

#include <iostream>
#include <string.h>

#include "osc/OscOutboundPacketStream.h"
#include "ip/IpEndpointName.h"
#include "ip/UdpSocket.h"


void sendMinuitMsg(int ip1, int ip2, int ip3, int ip4, int port){
  // formatting messages into a packet for sending:
    
    UdpTransmitSocket transmitSocket( IpEndpointName( "127.0.0.1", port ) );
    
    char buffer[1024];
    osc::OutboundPacketStream p( buffer, 1024 );
    
    p << osc::BeginBundleImmediate
        << osc::BeginMessage( "/test1" ) 
            << true << ip1 << ip2 << ip3 << ip4 << (float)3.1415 << "hello" << osc::EndMessage
        << osc::BeginMessage( "/test2" ) 
            << true << 24 << (float)10.8 << "world" << ip1 << osc::EndMessage
        << osc::EndBundle;
    
    transmitSocket.Send( p.Data(), p.Size() );

}
/*
 *  OSC.h
 *  OSCMinuit
 *
 *  Created by vernier on 18/05/09.
 *  Copyright 2009 University of Paris 11. All rights reserved.
 *
 */

#import "OSCMinuitReceiverPlugIn.h"
#import "InputDescriptor.h"

// dynamic sender
void startOSCMsg();
void addStringToOSCMsg(const char *name, const char *txt);
void addFloatToOSCMsg(const char *name, float value);
int finishOSCMsg(int, int, int, int, int);

// daemon / receiver
void openInputSocket(int, OSCMinuitReceiverPlugIn *);
void closeInputSocket();

// namespace
void getOSCNameSpace(int, int, int, int, int, NSMutableDictionary*);

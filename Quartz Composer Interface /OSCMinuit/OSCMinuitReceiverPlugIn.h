//
//  OSCMinuitReceiverPlugIn.h
//  OSCMinuitSender
//
//  Created by vernier on 19/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitReceiverViewController.h"

@interface OSCMinuitReceiverPlugIn : QCPlugIn {
  NSString          *newInputName;
  NSUInteger         port;
  NSMutableArray    *oscPathTable;
  OSCMinuitReceiverViewController *controller;
}

/*
Declare here the Obj-C 2.0 properties to be used as input and output ports for the plug-in e.g.
@property double inputFoo;
@property(assign) NSString* outputBar;
You can access their values in the appropriate plug-in methods using self.inputFoo or self.inputBar
*/

@property(assign) NSString          *newInputName;
@property         NSUInteger         port;
@property(retain) NSMutableArray    *oscPathTable;
@property(retain) OSCMinuitReceiverViewController *controller;
@end


@interface OSCMinuitReceiverPlugIn (Execution)
- (NSMutableDictionary*) getInfoForLeave:(NSString*) name;
- (NSMutableDictionary*) getNameSpaceForPrefix:(NSString*) prefix;
- (void) updateValue:(NSObject*) value forName:(NSString*) name;
@end
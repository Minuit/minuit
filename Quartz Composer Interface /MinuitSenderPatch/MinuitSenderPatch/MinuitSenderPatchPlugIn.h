//
//  MinuitSenderPatchPlugIn.h
//  MinuitSenderPatch
//
//  Created by vernier on 13/05/09.
//  Copyright (c) 2009 University of Paris 11. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "MinuitQCPlugInViewController.h"

@interface MinuitSenderPatchPlugIn : QCPlugIn
{
  NSString          *newInputName;
  NSUInteger         ip1;
  NSUInteger         ip2;
  NSUInteger         ip3;
  NSUInteger         ip4;
  NSUInteger         maxFrequency;
  NSUInteger         port;
  NSMutableArray    *oscPathTable;
}


/*
Declare here the Obj-C 2.0 properties to be used as input and output ports for the plug-in e.g.
@property double inputFoo;
@property(assign) NSString* outputBar;
You can access their values in the appropriate plug-in methods using self.inputFoo or self.inputBar
*/


@property(assign) NSString          *newInputName;
@property         NSUInteger         ip1;
@property         NSUInteger         ip2;
@property         NSUInteger         ip3;
@property         NSUInteger         ip4;
@property         NSUInteger         port;
@property         NSUInteger         maxFrequency;
@property(retain) NSMutableArray    *oscPathTable;
@end

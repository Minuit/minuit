//
//  OSCMinuitNameSpaceRetriever.h
//  OSCMinuit
//
//  Created by vernier on 25/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitNameSpaceRetrieverViewController.h"

@interface OSCMinuitNameSpaceRetrieverPlugIn : QCPlugIn {
  NSUInteger         port;
  NSUInteger         ip1;
  NSUInteger         ip2;
  NSUInteger         ip3;
  NSUInteger         ip4;  
  OSCMinuitNameSpaceRetrieverViewController *controller;  
}

@property(assign) BOOL inputUpdate;

@property         NSUInteger         port;
@property         NSUInteger         ip1;
@property         NSUInteger         ip2;
@property         NSUInteger         ip3;
@property         NSUInteger         ip4;
@property(retain) OSCMinuitNameSpaceRetrieverViewController* controller;
@property(assign) NSDictionary* outputNameSpace;
@end

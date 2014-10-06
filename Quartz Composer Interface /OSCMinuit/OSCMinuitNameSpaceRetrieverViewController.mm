//
//  OSCMinuitNameSpaceRetrieverViewController.m
//  OSCMinuit
//
//  Created by vernier on 25/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitNameSpaceRetrieverViewController.h"
#import "OSCMinuitNameSpaceRetrieverPlugIn.h"

@implementation OSCMinuitNameSpaceRetrieverViewController

// to replace exixting methods with something return the exact type ... avoiding warnings
-(OSCMinuitNameSpaceRetrieverPlugIn*) plugIn{
  return (OSCMinuitNameSpaceRetrieverPlugIn*)[super plugIn];
}


- (IBAction)update:(id)sender{
  [[self plugIn] getNamespace:self];
}

@end


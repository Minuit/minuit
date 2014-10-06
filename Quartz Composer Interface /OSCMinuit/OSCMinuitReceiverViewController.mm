//
//  OSCMinuitSenderViewController.m
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitReceiverViewController.h"
#import "OSCMinuitReceiverPlugIn.h"
#import "InputDescriptor.h"

@implementation OSCMinuitReceiverViewController

// to replace exixting methods with something return the exact type ... avoiding warnings
-(OSCMinuitReceiverPlugIn*) plugIn{
  return (OSCMinuitReceiverPlugIn*)[super plugIn];
}

-(void) awakeFromNib
{ 
  for (InputDescriptor *elem in [[self plugIn] oscPathTable]){
    if(![[elem suffix] hasPrefix:@"#"]  || ![[elem suffix] hasSuffix:@"#"])
      [inputNameTable addObject:elem];
    //NSLog(@" restore ui line");  
  }    
}


- (IBAction)addNamedFloat:(id)sender
{
  //printf("addNamedFloat:%p %p %p %p\n", self, [self plugIn], [[self plugIn] oscPathTable], [inputNameTable arrangedObjects]);
  
  if ([[newName stringValue] length]>0) {
    // add the input port of the plugin
    [[self plugIn] addOutputPortWithType:QCPortTypeNumber
                    forKey:[newName stringValue]
                    withAttributes:nil];
    // create an internal object to represent what we just did
    InputDescriptor *msg = [[InputDescriptor alloc] initWithSuffix:[newName stringValue] andType:@"Float"];
    // add this object to the UI table so the user can remove it later
    [inputNameTable addObject:msg];    
    // add it to an internal table saved when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];
  }
}

- (IBAction)addNamedString:(id)sender
{
  if ([[newName stringValue] length]>0) {
    // add the input port of the plugin
    [[self plugIn] addOutputPortWithType:QCPortTypeString
                    forKey:[newName stringValue]
                    withAttributes:nil];
    // create an internal object to represent what we just did
    InputDescriptor *msg = [[InputDescriptor alloc] initWithSuffix:[newName stringValue] andType:@"String"];
    // add this object to the UI table so the user can remove it later
    [inputNameTable addObject:msg];    
    // add it to an internal table saved when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];
  }
}


- (IBAction)remove:(id)sender{
  NSArray* sels = [inputNameTable selectedObjects];
  //for(id element in sels) 
  //  NSLog(@"removing element ? :%@*\n", [element suffix]);

  //NSArray* list = [[[self plugIn]oscPathTable] arrangedObjects];
  id foundelem = nil;
  for(id element in sels) {
    for(id port in [[self plugIn]oscPathTable]) {
      if (([[element suffix] hasPrefix:[@"/" stringByAppendingString:[port suffix]]] && [[port suffix] hasPrefix:@"#"]  && [[port suffix] hasSuffix:@"#"]) ||
           ([[port suffix] hasPrefix:[@"/" stringByAppendingString:[element suffix]]] && [[element suffix] hasPrefix:@"#"]  && [[element suffix] hasSuffix:@"#"])){
        foundelem = port;
      }     }
    
    if (foundelem != nil){
      //NSLog(@"port:%@ is related to %@ and will be deleted too\n", [foundelem suffix], [element suffix]);
      if(![[foundelem suffix] hasPrefix:@"#"]  || ![[foundelem suffix] hasSuffix:@"#"])
        [inputNameTable removeObject:foundelem];
      [[self plugIn] removeOutputPortForKey:[foundelem suffix]];
      [[[self plugIn]oscPathTable] removeObject:foundelem];  
      
    }
    //NSLog(@"remove element:%@*\n", [element suffix]);
    if(![[element suffix] hasPrefix:@"#"]  || ![[element suffix] hasSuffix:@"#"])
      [inputNameTable removeObject:element];
    [[self plugIn] removeOutputPortForKey:[element suffix]];
    [[[self plugIn]oscPathTable] removeObject:element];  
  }
}

@end

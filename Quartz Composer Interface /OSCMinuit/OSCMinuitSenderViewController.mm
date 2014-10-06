//
//  OSCMinuitSenderViewController.m
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitSenderViewController.h"
#import "OSCMinuitSenderPlugIn.h"
#import "InputDescriptor.h"
#import "OSCMinuitSenderPlugIn.h"

@implementation OSCMinuitSenderViewController

-(OSCMinuitSenderPlugIn*) plugIn{
  return (OSCMinuitSenderPlugIn*)[super plugIn];
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
    [[self plugIn] addInputPortWithType:QCPortTypeNumber
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

- (IBAction)addSuffixedFloat:(id)sender{
  int i = 0;
  NSString *entry = [NSString stringWithFormat:@"#prefix%i#", i];
  
  // look for a free name
  //NSArray* list = [inputNameTable arrangedObjects];
  BOOL found = TRUE;
  while (found){
    found  = FALSE;
    for(id port in [[self plugIn]oscPathTable]) {
      if ([[port suffix] hasSuffix:entry]){
        found =TRUE;
        //printf("port:%s*\n", [[port suffix]UTF8String]);
        break;
      } //else
        //printf("port:%s\n", [[port suffix]UTF8String]);
    }
    if (found) i++;
    entry = [NSString stringWithFormat:@"#prefix%i#", i];
  }

  if ([[newName stringValue] length]>=0) {
    NSString *newLongName = [[@"/" stringByAppendingString:entry]stringByAppendingString:[newName stringValue]];
    [[self plugIn] addInputPortWithType:QCPortTypeNumber
                    forKey:newLongName
                    withAttributes:nil];
    [[self plugIn] addInputPortWithType:QCPortTypeString
                    forKey:entry
                    withAttributes:nil];  
    // create an internal object to represent what we just did
    InputDescriptor *msg = [[InputDescriptor alloc] initWithSuffix:newLongName andType:@"Float"];
    // add this object to the UI table so the user can remove it later
    [inputNameTable addObject:msg];    
    // add it to an internal table saved when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];                           
    // create an internal object to represent what we just did
    msg = [[InputDescriptor alloc] initWithSuffix:entry andType:@"String"];   
    // add it to an internal table saved when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];      
  }
}

- (IBAction)addNamedString:(id)sender
{
  if ([[newName stringValue] length]>0) {
    // add the input port of the plugin
    [[self plugIn] addInputPortWithType:QCPortTypeString
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

- (IBAction)addSuffixedString:(id)sender{
  int i = 0;
  NSString *entry = [NSString stringWithFormat:@"#prefix%i#", i];
  
  // look for a free name
  //NSArray* list = [inputNameTable arrangedObjects];
  BOOL found = TRUE;
  while (found){
    found  = FALSE;
    for(id port in [[self plugIn]oscPathTable]) {
      if ([[port suffix] hasSuffix:entry]){
        found =TRUE;
        //printf("port:%s*\n", [[port suffix]UTF8String]);
        break;
      } //else
        //printf("port:%s\n", [[port suffix]UTF8String]);
    }
    if (found) i++;
    entry = [NSString stringWithFormat:@"#prefix%i#", i];
  }

  if ([[newName stringValue] length]>=0) {
    NSString *newLongName = [[@"/" stringByAppendingString:entry]stringByAppendingString:[newName stringValue]];
    [[self plugIn] addInputPortWithType:QCPortTypeString//xxx
                    forKey:newLongName
                    withAttributes:nil];
    [[self plugIn] addInputPortWithType:QCPortTypeString
                    forKey:entry
                    withAttributes:nil];  
    // create an internal object to represent what we just did
    InputDescriptor *msg = [[InputDescriptor alloc] initWithSuffix:newLongName andType:@"String"];//xxx
    // add this object to the UI table so the user can remove it later
    [inputNameTable addObject:msg];    
    // add it to an internal table saved when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];                           
    // create an internal object to represent what we just did
    msg = [[InputDescriptor alloc] initWithSuffix:entry andType:@"String"];   
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
      [[self plugIn] removeInputPortForKey:[foundelem suffix]];
      [[[self plugIn]oscPathTable] removeObject:foundelem];  
      
    }
    //NSLog(@"remove element:%@*\n", [element suffix]);
    if(![[element suffix] hasPrefix:@"#"]  || ![[element suffix] hasSuffix:@"#"])
      [inputNameTable removeObject:element];
    [[self plugIn] removeInputPortForKey:[element suffix]];
    [[[self plugIn]oscPathTable] removeObject:element];  
  }
}

@end

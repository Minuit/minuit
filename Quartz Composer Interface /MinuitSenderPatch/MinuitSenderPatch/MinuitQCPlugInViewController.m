//
//  MinuitQCPlugInViewController.m
//  MinuitSenderPatch
//
//  Created by vernier on 15/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "MinuitQCPlugInViewController.h"
#import "MinuitSenderPatchPlugIn.h"
#import "OSCMsg.h"

@implementation MinuitQCPlugInViewController

/*-(void) awakeFromNib
{ 
  NSLog("FREDDDD");
}*/

- (id) initWithPlugIn:(QCPlugIn*)plugIn viewNibName:(NSString*)name{
  id res = [super initWithPlugIn:plugIn viewNibName:name];
  for (OSCMsg *msg in [[self plugIn] oscPathTable]){
    [msgTable addObject:msg];
    NSLog(@" restore ui line");  
  }  
  return res;
}



- (IBAction)addNamedFloat:(id)sender
{
  printf("addNamedFloat:%p %p %p %p\n", self, [self plugIn], [[self plugIn] oscPathTable], [msgTable arrangedObjects]);
  
  if ([[newName stringValue] length]>0) {
    // add the input port of the plugin
    [[self plugIn] addInputPortWithType:QCPortTypeNumber
                    forKey:[newName stringValue]
                    withAttributes:nil];
    // create an internal object to represent what we just did
    OSCMsg *msg = [[OSCMsg alloc] initWithSuffix:[newName stringValue] andType:@"Float"];
    // add this object to the UI table so the user can remove it later
    [msgTable addObject:msg];    
    // add it to an internal table savec when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];
  }
}

- (IBAction)addSuffixedFloat:(id)sender{
  int i = 0;
  NSString *entry = [NSString stringWithFormat:@"#name%i#", i];
  
  // look for a free name
  NSArray* list = [msgTable arrangedObjects];
  BOOL found = TRUE;
  while (found){
    found  = FALSE;
    for(id port in list) {
      if ([[port suffix] hasSuffix:entry]){
        found =TRUE;
        //printf("port:%s*\n", [[port suffix]UTF8String]);
        break;
      } //else
        //printf("port:%s\n", [[port suffix]UTF8String]);
    }
    if (found) i++;
    entry = [NSString stringWithFormat:@"#name%i#", i];
  }

  if ([[newName stringValue] length]>0) {
    NSString *newLongName = [[[newName stringValue] stringByAppendingString:@"/"] stringByAppendingString:entry];
    [[self plugIn] addInputPortWithType:QCPortTypeNumber
                    forKey:newLongName
                    withAttributes:nil];
    [[self plugIn] addInputPortWithType:QCPortTypeString
                    forKey:entry
                    withAttributes:nil];  
    // create an internal object to represent what we just did
    OSCMsg *msg = [[OSCMsg alloc] initWithSuffix:newLongName andType:@"Float"];
    // add this object to the UI table so the user can remove it later
    [msgTable addObject:msg];    
    // add it to an internal table savec when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];                           
    // create an internal object to represent what we just did
    msg = [[OSCMsg alloc] initWithSuffix:entry andType:@"Float"];
    // add this object to the UI table so the user can remove it later
    [msgTable addObject:msg];    
    // add it to an internal table savec when the composition is saved so it could be restored when reloaded
    [[[self plugIn]oscPathTable] addObject:msg];      
  }
}

- (IBAction)addNamedString:(id)sender
{
  if ([[newName stringValue] length]>0) {
    [[self plugIn] addInputPortWithType:QCPortTypeString
                    forKey:[newName stringValue]
                    withAttributes:nil];
    [msgTable addObject:[[OSCMsg alloc] initWithSuffix:[newName stringValue] andType:@"String"]];      
  }
}

- (IBAction)addSuffixedString:(id)sender{
}

- (IBAction)remove:(id)sender{
  NSArray* sels = [msgTable selectedObjects];
  NSArray* list = [msgTable arrangedObjects];
  for(id element in sels) {
    for(id port in list) {
      if ([[element suffix] hasSuffix:[port suffix]] && element!=port){
        printf("port:%s*\n", [[port suffix]UTF8String]);
        [msgTable removeObject:port];
        [[self plugIn] removeInputPortForKey:[port suffix]];
      } else
        printf("port:%s is not suffix of %s\n", [[port suffix]UTF8String], [[element suffix]UTF8String]);
    }
    //printf("port:%s*\n", [[port suffix]UTF8String]);
    [msgTable removeObject:element];
    [[self plugIn] removeInputPortForKey:[element suffix]];
  }
}

@end

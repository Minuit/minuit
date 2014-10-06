//
//  OSCMinuitReceiverPlugIn.m
//  OSCMinuitSender
//
//  Created by vernier on 19/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
//#import <OpenGL/CGLMacro.h>


#include "OSC.h"
#import "InputDescriptor.h"
#import "OSCMinuitReceiverPlugIn.h"
#import <Foundation/NSRange.h>

#define	kQCPlugIn_Name				@"OSC-Minuit Receiver"
#define	kQCPlugIn_Description	@"OSCMinuitReceiver broadcasts first the list of messages it acceptd and then listen/receives messages through OSC2.0-Minuit network protocol"


/*
Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
@dynamic inputFoo, outputBar;
*/
@implementation OSCMinuitReceiverPlugIn

@synthesize port, oscPathTable, controller, newInputName;

+ (NSDictionary*) attributes
{
	/*
	Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
	*/
	
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	/*
	Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
	*/
	
	return nil;
}

+ (QCPlugInExecutionMode) executionMode
{
	/*
	Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	*/
	
	return kQCPlugInExecutionModeProvider ;
}

+ (QCPlugInTimeMode) timeMode
{
	/*
	Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	*/
	
	return kQCPlugInTimeModeIdle;
}

- (id) init
{
	if(self = [super init]) {
    self.port = 60004; 
    self.newInputName = @"/test";    
    self.oscPathTable = [[[NSMutableArray alloc] init] retain];
	}
	
	return self;
}

- (void) finalize
{
	/*
	Release any non garbage collected resources created in -init.
	*/
	[self.oscPathTable release];
	[super finalize];
}

- (void) dealloc
{
	/*
	Release any resources created in -init.
	*/
	
	[super dealloc];
}

+ (NSArray*) plugInKeys
{
	/*
	Return a list of the KVC keys corresponding to the internal settings of the plug-in.
	*/
	
  return [NSArray arrayWithObjects: @"port", @"oscPathTable", nil];
}

- (id) serializedValueForKey:(NSString*)key;
{
	/*
	Provide custom serialization for the plug-in internal settings that are not values complying to the <NSCoding> protocol.
	The return object must be nil or a PList compatible i.e. NSString, NSNumber, NSDate, NSData, NSArray or NSDictionary.
	*/
	
	return [super serializedValueForKey:key];
}

- (void) setSerializedValue:(id)serializedValue forKey:(NSString*)key
{
	/*
	Provide deserialization for the plug-in internal settings that were custom serialized in -serializedValueForKey.
	Deserialize the value, then call [self setValue:value forKey:key] to set the corresponding internal setting of the plug-in instance to that deserialized value.
	*/
	
	[super setSerializedValue:serializedValue forKey:key];
  if ([key compare:@"oscPathTable"]==NSOrderedSame){
    for (InputDescriptor *elem in self.oscPathTable){
      if ([elem.type compare:@"Float"]==NSOrderedSame)
        [self  addOutputPortWithType:QCPortTypeNumber
               forKey:elem.suffix
               withAttributes:nil];
      else if ([elem.type compare:@"String"]==NSOrderedSame)
        [self  addOutputPortWithType:QCPortTypeString
               forKey:elem.suffix
               withAttributes:nil];
    }
  }

}

- (QCPlugInViewController*) createViewController
{
	/*
	Return a new QCPlugInViewController to edit the internal settings of this plug-in instance.
	You can return a subclass of QCPlugInViewController if necessary.
	*/
	
	controller = [[OSCMinuitReceiverViewController alloc] initWithPlugIn:self viewNibName:@"SettingsReceiver"];
  [controller retain];
  return controller;
}

@end


@implementation OSCMinuitReceiverPlugIn (Execution)

- (NSMutableDictionary*) getInfoForLeave:(NSString*) name {
  NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
  for (InputDescriptor *elem in self.oscPathTable) {
    if ([[elem suffix] compare:name]==NSOrderedSame){
      [info setValue:elem.type forKey:@"type"];
      [info setValue:elem.value forKey:@"value"];
    }
  }
  return info;
}


- (NSMutableDictionary*) getNameSpaceForPrefix:(NSString*) prefix {
  NSMutableDictionary* nameSpace = [[NSMutableDictionary alloc] init];
  //NSLog(@"getNameSpaceForPrefix: %@ ", prefix);
  for (InputDescriptor *elem in self.oscPathTable) {
    if ([elem.suffix hasPrefix:prefix] && [elem.suffix compare:prefix]!=NSOrderedSame){
      NSString *end=[elem.suffix substringFromIndex:[prefix length]];
      //NSLog(@"  Should add %@ = %@ with prefix %@", end, elem.suffix, prefix);

      // removing the first /
      if ([end rangeOfString:@"/"].location == 0) {
        end = [end substringFromIndex:1];
      }
      
      // it is a node and a suffix. remove the suffix
      if ([end rangeOfString:@"/"].location != NSNotFound) {
        end = [end substringToIndex:[end rangeOfString:@"/"].location];
        if([nameSpace valueForKey:end]!=nil && [[[nameSpace valueForKey:end] class] isSubclassOfClass:[InputDescriptor class]]){
          NSLog(@"  CAN't BE A NODE AND A LEAF %@", end);   
          return nil; 
        } else if ([nameSpace valueForKey:end]!=nil){
          [nameSpace setValue:[[NSNumber alloc] initWithInt:1+[[nameSpace valueForKey:end] intValue]] forKey:end];
        } else
          [nameSpace setValue:[[NSNumber alloc] initWithInt:0] forKey:end];
      } else { //it's a leaf, add the InputDescriptor
      if ([nameSpace valueForKey:end]!=nil) {
        NSLog(@"  CAN't BE A NODE AND A LEAF %@", end);          
        return nil;
      } else
        [nameSpace setValue:elem forKey:end];      
      }
      
    }
  }
  return nameSpace;
}

- (void) updateValue:(NSObject*) value forName:(NSString*) name {
  for (InputDescriptor *elem in self.oscPathTable){
    if ([elem.suffix compare:name]==NSOrderedSame){
      [elem setValue:value];
    }
  }
}

- (void) openMinuit:(id)param{
    openInputSocket(self.port, self);  
}

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	*/
	[NSThread detachNewThreadSelector:@selector(openMinuit:) toTarget:self withObject:nil];
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
	*/
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	/*
	Called by Quartz Composer whenever the plug-in instance needs to execute.
	Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
	Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).
	
	The OpenGL context for rendering can be accessed and defined for CGL macros using:
	CGLContextObj cgl_ctx = [context CGLContextObj];
	*/
  
  for (InputDescriptor *elem in self.oscPathTable){
    if (elem.value==nil){
      //NSLog(@"%@ never received...", elem.suffix);
    } else if ([elem value]!=nil && [[[elem value] class] isSubclassOfClass:[NSNumber class]]){
      [self setValue:(NSNumber*)(elem.value) forOutputKey:elem.suffix];
    } else if ([elem value]!=nil && [[[elem value] class] isSubclassOfClass:[NSString class]]){
      [self setValue:(NSString*)(elem.value) forOutputKey:elem.suffix];    
    } else {
      NSLog(@"%@ IS UNKNOWN(%@)", elem.suffix, elem.value);
    }
  }
	
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
	*/
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
	*/
  closeInputSocket();  
}

@end


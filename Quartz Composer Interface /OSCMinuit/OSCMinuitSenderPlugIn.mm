//
//  OSCMinuitSenderPlugIn.m
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
//#import <OpenGL/CGLMacro.h>


#include "OSC.h"
#import "InputDescriptor.h"
#import "OSCMinuitSenderPlugIn.h"

#define	kQCPlugIn_Name				@"OSC-Minuit Sender"
#define	kQCPlugIn_Description	@"OSCMinuitSender sends  messages through OSC2.0-Minuit network protocol"

/*
Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
@dynamic inputFoo, outputBar;
*/
@implementation OSCMinuitSenderPlugIn

@synthesize ip1, ip2, ip3, ip4, maxFrequency, port, newInputName, oscPathTable, controller;

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
	
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode
{
	/*
	Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	*/
	
	return kQCPlugInTimeModeNone;
}

- (id) init
{
	if(self = [super init]) {
    self.ip1 = 127; 
    self.ip2 = 0; 
    self.ip3 = 0; 
    self.ip4 = 1; 
       
    self.port = 60004; 
    self.maxFrequency = 30; 
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
	
  return [NSArray arrayWithObjects:@"ip1", @"ip2", @"ip3", @"ip4", @"port", @"maxFrequency", @"oscPathTable", nil];
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
      //xxx
      if ([elem.type compare:@"Float"]==NSOrderedSame)
        [self  addInputPortWithType:QCPortTypeNumber
               forKey:elem.suffix
               withAttributes:nil];
      else if ([elem.type compare:@"String"]==NSOrderedSame)
        [self  addInputPortWithType:QCPortTypeString
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
	
	controller = [[OSCMinuitSenderViewController alloc] initWithPlugIn:self viewNibName:@"SettingsSender"];
  [controller retain];
  return controller;
}

@end

@implementation OSCMinuitSenderPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	*/
	
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
  

    startOSCMsg();
    for (InputDescriptor *elem in self.oscPathTable){
      //NSLog(@"msg to send %@ %@ %i %i", elem.suffix, elem.type, ([elem.type compare:@"String"]==NSOrderedSame) , ([elem.suffix hasPrefix:@"/#prefix"]));
      NSString *resolvedName = elem.suffix;
      
      if ([elem.suffix hasPrefix:@"/#prefix"]){
        //NSLog(@"  resolving  %@...", elem.suffix);
        resolvedName = NULL;
        for(InputDescriptor *otherelem in self.oscPathTable) {
          if ([otherelem.type compare:@"String"]==NSOrderedSame && [[elem suffix] hasPrefix:[@"/" stringByAppendingString:[otherelem suffix]]]){
            //NSLog(@"    found %@...", otherelem.suffix);
            NSString *prefix = [self valueForInputKey:otherelem.suffix];
            //NSLog(@"    replacing with %@...", prefix);
            resolvedName = [elem.suffix stringByReplacingOccurrencesOfString:otherelem.suffix withString:prefix];
            //NSLog(@"    resolved as %@...", resolvedName);
            break;
          } 
        }
      } 
      
      //NSLog(@" Sending %@ %@", resolvedName, [self valueForInputKey:elem.suffix]);
      if ([elem.type compare:@"Float"]==NSOrderedSame && ![elem.suffix hasPrefix:@"#prefix"]) {
        NSNumber *val = [self valueForInputKey:elem.suffix];
        elem.value = val;
        addFloatToOSCMsg([resolvedName UTF8String], [val floatValue]);
      } else if ([elem.type compare:@"String"]==NSOrderedSame && ![elem.suffix hasPrefix:@"#prefix"]) {
        NSString *val = [self valueForInputKey:elem.suffix];
        elem.value = val;
        addStringToOSCMsg([resolvedName UTF8String], [val UTF8String]);
      }
    }    
    finishOSCMsg(self.ip1, self.ip2, self.ip3, self.ip4, self.port);
	
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
}

@end

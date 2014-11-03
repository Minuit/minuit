//
//  MinuitSenderPatchPlugIn.m
//  MinuitSenderPatch
//
//  Created by vernier on 13/05/09.
//  Copyright (c) 2009 University of Paris 11. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>

#import "MinuitSenderPatchPlugIn.h"
#include "OSC.h"
#import "OSCMsg.h"

#define	kQCPlugIn_Name        @"MinuitSenderPatch"
#define	kQCPlugIn_Description	@"MinuitSenderPatch sends the message msg through OSC2.0-Minuit network protocol"

@implementation MinuitSenderPatchPlugIn

/*
Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
@dynamic inputFoo, outputBar;
*/

@synthesize ip1, ip2, ip3, ip4, maxFrequency, port, newInputName, oscPathTable;

MinuitQCPlugInViewController *controller;

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
	
       if([key isEqualToString:@"inputPrefix"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"path prefix", QCPortAttributeNameKey,
                @"/", QCPortAttributeDefaultValueKey,
                nil]; 
    if([key isEqualToString:@"inputMsg"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"msg", QCPortAttributeNameKey,
                @"hello minuit 0 23,45", QCPortAttributeDefaultValueKey,
                nil]; 
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
		/*
		Allocate any permanent resource required by the plug-in.
		*/
       self.ip1 = 127; 
       self.ip2 = 0; 
       self.ip3 = 0; 
       self.ip4 = 1; 
       
       self.port = 60004; 
       self.maxFrequency = 30; 
       self.newInputName = @"/test";
       self.oscPathTable = [[[NSMutableArray alloc] init] retain];
       //[self.oscPathTable addObject:[[OSCMsg alloc] initWithSuffix:@"/toto" andType:@"Float"]];
       printf("init:%p\n", [self oscPathTable]);
	}
	
	return self;
}

- (void) finalize
{
	/*
	Release any non garbage collected resources created in -init.
	*/
	
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
  NSLog(@"serializedValueForKey\n");	
	return [super serializedValueForKey:key];
}

- (void) setSerializedValue:(id)serializedValue forKey:(NSString*)key
{
	/*
	Provide deserialization for the plug-in internal settings that were custom serialized in -serializedValueForKey.
	Deserialize the value, then call [self setValue:value forKey:key] to set the corresponding internal setting of the plug-in instance to that deserialized value.
	*/
  NSLog(@"setSerializedValue\n");
	[super setSerializedValue:serializedValue forKey:key];
  //NSLog(@"deser : %@", key);
  if ([key compare:@"oscPathTable"]==NSOrderedSame){
    //NSLog(@"lui ! ");
    for (OSCMsg *msg in self.oscPathTable){
      if ([msg.type compare:@"Float"]==NSOrderedSame){
        [self  addInputPortWithType:QCPortTypeNumber
               forKey:msg.suffix
               withAttributes:nil];
        // adding it to the UI
        //[[controller getUIMsgTable] addObject:msg];
      NSLog(@" create input port");  
      }
      NSLog(@" - %@=%@ ", msg.suffix, msg.type);  
    }
  }
	
}

- (QCPlugInViewController*) createViewController
{
	/*
	Return a new QCPlugInViewController to edit the internal settings of this plug-in instance.
	You can return a subclass of QCPlugInViewController if necessary.
	*/
  NSLog(@"create ui controller\n");
	controller = [[MinuitQCPlugInViewController alloc] initWithPlugIn:self viewNibName:@"Settings"];
  [controller retain];
  NSLog(@"controller created\n");
  return controller;
}

@end

@implementation MinuitSenderPatchPlugIn (Execution)

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

  sendMinuitMsg(self.ip1, self.ip2, self.ip3, self.ip4, self.port);
	
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

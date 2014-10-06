//
//  OSCMinuitNameSpaceRetriever.m
//  OSCMinuit
//
//  Created by vernier on 25/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMinuitNameSpaceRetrieverPlugIn.h"
#include "OSC.h"
#import "InputDescriptor.h"

#define	kQCPlugIn_Name				@"OSC-Minuit Namespace retriever"
#define	kQCPlugIn_Description	@"OSCMinuitNamespaceRetriever retrieve the namespace (list of inputs) of a remote listener"




@implementation OSCMinuitNameSpaceRetrieverPlugIn
@dynamic outputNameSpace, inputUpdate;
@synthesize port, controller, ip1, ip2, ip3, ip4;
NSMutableDictionary *ns;

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

  if([key isEqualToString:@"outputNameSpace"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
            @"NameSpace", QCPortAttributeNameKey,
            nil];
 if([key isEqualToString:@"inputUpdate"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Update", QCPortAttributeNameKey,
            [NSNumber numberWithUnsignedInteger:0],  QCPortAttributeDefaultValueKey,
            nil];
   
	return nil;
}

+ (QCPlugInExecutionMode) executionMode
{
	/*
	Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	*/
	
	return kQCPlugInExecutionModeProcessor;
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
  NSLog(@"init");
	if(self = [super init]) {
    self.ip1 = 127; 
    self.ip2 = 0; 
    self.ip3 = 0; 
    self.ip4 = 1; 
    self.port = 60004; 
    ns = [[[NSMutableDictionary alloc] init] retain];
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
	
  return [NSArray arrayWithObjects: @"port", @"ip1", @"ip2", @"ip3", @"ip4", nil];
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
}

- (QCPlugInViewController*) createViewController
{
	/*
	Return a new QCPlugInViewController to edit the internal settings of this plug-in instance.
	You can return a subclass of QCPlugInViewController if necessary.
	*/
	
	controller = [[OSCMinuitNameSpaceRetrieverViewController alloc] initWithPlugIn:self viewNibName:@"SettingsNameSpace"];
  [controller retain];
  return controller;
}

@end



@implementation OSCMinuitNameSpaceRetrieverPlugIn (Execution)

-(void) getNamespace:(id)param{
  //NSLog(@"getNamespace");
  getOSCNameSpace(self.ip1, self.ip2, self.ip3, self.ip4, self.port, ns);  
}


- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	*/
  //NSLog(@"startExecution");
  //[NSThread detachNewThreadSelector:@selector(getNamespace:) toTarget:self withObject:nil];
  [self getNamespace:self];
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
  //self.nameSpace = [NSDictionary dictionaryWithObjectsAndKeys:
  //          @"/toto", @"name", nil];
  if (self.inputUpdate)
    [self getNamespace:self];
  self.outputNameSpace  = [NSDictionary dictionaryWithDictionary:ns];
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
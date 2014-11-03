//
//  OSCMsg.m
//  MinuitSenderPatch
//
//  Created by vernier on 15/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "OSCMsg.h"


@implementation OSCMsg

-(id)initWithSuffix:(NSString*)_suffix andType:(NSString*)_type
{  
     if ( self = [super init]) {  
        [self setSuffix:_suffix];  
        [self setType:_type];  
    }  
    return self;  
} 

- (void)encodeWithCoder:(NSCoder *)encoder{
NSLog(@"here1"); 
  [encoder encodeObject:suffix forKey:@"suffix"];
  [encoder encodeObject:type forKey:@"type"];
}
- (id)initWithCoder:(NSCoder *)decoder{
NSLog(@"here2"); 
  NSString *_suffix = [decoder decodeObjectForKey:@"suffix"];
  NSString *_type = [decoder decodeObjectForKey:@"type"];
  return [[OSCMsg alloc] initWithSuffix:_suffix andType:_type];
}

-(NSString*)suffix  {return suffix;}
-(void)setSuffix:(NSString*)aSuffix
{  
    if (aSuffix != suffix) {  
        [suffix release];  
        [aSuffix retain];  
        suffix = aSuffix;  
    }  
} 

-(NSString*)type  {return type;}
-(void)setType:(NSString*)aType
{  
    if (aType != type) {  
        [type release];  
        [aType retain];  
        type = aType;  
    }  
} 

@end

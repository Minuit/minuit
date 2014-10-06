//
//  InputDescriptor.m
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import "InputDescriptor.h"


@implementation InputDescriptor

-(id)initWithSuffix:(NSString*)_suffix andType:(NSString*)_type
{  
     if ( self = [super init]) {  
        [self setSuffix:_suffix];  
        [self setType:_type]; 
        if ([_type compare:@"String"]==NSOrderedSame)
          [self setValue:@""];
        else if ([_type compare:@"Float"]==NSOrderedSame)
          [self setValue:[[NSNumber alloc] initWithFloat:0]];
        else [self setValue:nil];  
    }  
    return self;  
} 

- (void)encodeWithCoder:(NSCoder *)encoder
{
  //NSLog(@"here1"); 
  [encoder encodeObject:suffix forKey:@"suffix"];
  [encoder encodeObject:type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  //NSLog(@"here2"); 
  NSString *_suffix = [decoder decodeObjectForKey:@"suffix"];
  NSString *_type = [decoder decodeObjectForKey:@"type"];
  return [[InputDescriptor alloc] initWithSuffix:_suffix andType:_type];
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

-(NSObject*)value  {return value;}
-(void)setValue:(NSObject*)aValue
{  
    if (aValue != value) {  
        [value release];  
        [aValue retain];  
        value = aValue;  
    }  
} 

@end

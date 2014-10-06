//
//  InputDescriptor.h
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InputDescriptor : NSObject {
  NSString *suffix;
  NSString *type;
  NSObject *value;
}

-(id)initWithSuffix:(NSString*)suffix andType:(NSString*)type;

-(NSString*)suffix;  
-(void)setSuffix:(NSString*)aSuffix;  
-(NSString*)type;  
-(void)setType:(NSString*)aType;

-(NSObject*)value;  
-(void)setValue:(NSObject*)aValue;

@end

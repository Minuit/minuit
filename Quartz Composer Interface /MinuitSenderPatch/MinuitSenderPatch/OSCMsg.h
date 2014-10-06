//
//  OSCMsg.h
//  MinuitSenderPatch
//
//  Created by vernier on 15/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface OSCMsg : NSObject {
  NSString *suffix;
  NSString *type;
}

-(id)initWithSuffix:(NSString*)suffix andType:(NSString*)type;

-(NSString*)suffix;  
-(void)setSuffix:(NSString*)aSuffix;  
-(NSString*)type;  
-(void)setType:(NSString*)aType;


@end

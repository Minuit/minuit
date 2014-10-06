//
//  OSCMinuitSenderViewController.h
//  OSCMinuitSender
//
//  Created by vernier on 18/05/09.
//  Copyright 2009 University of Paris 11. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface OSCMinuitSenderViewController : QCPlugInViewController {
  IBOutlet id inputNameTable;
  IBOutlet id newName;
}

//- (id) initWithPlugIn:(QCPlugIn*)plugIn viewNibName:(NSString*)name;
- (IBAction)addNamedFloat:(id)sender;
- (IBAction)addSuffixedFloat:(id)sender;
- (IBAction)addNamedString:(id)sender;
- (IBAction)addSuffixedString:(id)sender;
- (IBAction)remove:(id)sender;

@end

//
//  PspctTableCellView.h
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PspctContentController;

@interface PspctTableCellView : NSTableCellView{
    PspctContentController *controller;
    NSInteger row;
}

@property (readwrite) NSInteger row;
@property (nonatomic, retain) PspctContentController *controller;

@end
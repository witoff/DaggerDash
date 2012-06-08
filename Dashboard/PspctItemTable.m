//
//  PspctItemTable.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctItemTable.h"

@implementation PspctItemTable

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/*
- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}
*/

-(void)swipeWithEvent:(NSEvent *)event
{
    NSLog(@"swipe: %@", event);
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    NSLog(@"mouse drag pspct item table");
}

-(void)mouseEntered:(NSEvent *)theEvent{
    NSLog(@"mouse");
}

@end

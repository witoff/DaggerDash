//
//  PspctTestView.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctTestView.h"

@implementation PspctTestView

- (id)initWithFrame:(NSRect)frame
{
    NSLog(@"initwithframearstarst");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"enter: number: %ld, click: %ld", [theEvent buttonNumber], [theEvent clickCount]);
}

-(void)mouseEntered:(NSEvent *)theEvent{
    NSLog(@"enter!");
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    NSLog(@"mouse drag");
}

-(void)swipeWithEvent:(NSEvent *)event{
    NSLog(@"swipe");
}
@end

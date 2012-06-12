//
//  PspctItemTable.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctItemTable.h"
#import "PspctContentController.h"

@implementation PspctItemTable

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
    }
    
    return self;
}

/*
 -(void)swipeWithEvent:(NSEvent *)event
 {
 NSLog(@"swipe: %@", event);
 }
 
 -(void)mouseDragged:(NSEvent *)theEvent
 {
 NSLog(@"mouse drag pspct item table");
 }
 */
-(void)updateTrackingAreas{    
    NSTrackingArea *area = [self.trackingAreas objectAtIndex:0];
    [self removeTrackingArea:area];
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
    
}
-(void)mouseEntered:(NSEvent *)theEvent{
    [[self.window animator] setAlphaValue:.9];
    //[self.window setAlphaValue:.85];
}
-(void)mouseExited:(NSEvent *)theEvent {
        [[self.window animator] setAlphaValue:.8];
    //[self.window setAlphaValue:.6];
}


-(void)noResponderFor:(SEL)eventSelector{
    logDebug(@"pspct item table: noresponder for");
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:p];
    
    if (theEvent.clickCount==2){        
        PspctContentController* controller = (PspctContentController*)self.delegate;
        [controller openFile:row];
    }    
    [super mouseDown:theEvent];
}



-(void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"keycode: %i", theEvent.keyCode);
    
    NSInteger row = [self selectedRow];
    PspctContentController* controller = (PspctContentController*)self.delegate;
    if (theEvent.modifierFlags==1048848 && theEvent.keyCode==1)
    {
        //Pressing Command-R
        [controller openFolder:row];
        
    }
    else if (theEvent.keyCode==36)
    {
        //Enter
        [controller openFile:row];
    }
    else if (theEvent.keyCode==51 || theEvent.keyCode==117)
    {
        //Backspace or Delete
        [controller deleteTag:row];
    }
    else
        [super keyDown:theEvent];
}

@end

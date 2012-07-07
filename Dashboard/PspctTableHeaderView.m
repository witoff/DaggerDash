//
//  PspctTableHeaderView.m
//  DaggerDash
//
//  Created by Robert Witoff on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctTableHeaderView.h"
#import "PspctAppDelegate.h"

@implementation PspctTableHeaderView

@synthesize textView, commentText;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) { 
        

    }
    return self;
}

-(void)viewWillDraw{
    [super viewWillDraw];
    self.commentText.delegate = self;
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    logDebug(@"save comment");
    PspctAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate.daggerComments setObject:commentText.stringValue forKey:self.textField.stringValue];
    [delegate saveComments];
}

@end

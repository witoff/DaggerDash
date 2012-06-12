//
//  PspctTableCellView.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctTableCellView.h"
#import "PspctContentController.h"

@implementation PspctTableCellView

@synthesize row, controller;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerForDraggedTypes:qArray(NSFilenamesPboardType)];
        //NSURLPboardType <- can only be one url.  Can't accept multiple
    }
    return self;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    logDebug(@"drag entered");
    return NSDragOperationMove;
}

-(void)noResponderFor:(SEL)eventSelector{
    logDebug(@"pspct item table: noresponder for");
}
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        
        NSString *dagger = [self.controller getDaggerForRow:self.row];
        dagger = [qArray(@"†", dagger) componentsJoinedByString:@""];
        
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in files) {
            NSString *newPath = [NSString stringWithFormat:@"%@ %@.%@", [path stringByDeletingPathExtension], dagger, [path pathExtension]];
            
            logDebug(@"old path: %@", path);
            logDebug(@"new path: %@", newPath);
            [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:nil];
        }
    }
    
    return YES;
}

@end

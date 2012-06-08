//
//  PspctFileTypeCell.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctFileTypeCell.h"

@implementation PspctFileTypeCell

@synthesize _image, _title;


- (id)copyWithZone:(NSZone *)zone
{
    PspctFileTypeCell *cell = [super copyWithZone:zone];
    if (cell == nil) {
        return nil;
    }
    
    // Clear the image and subtitle as they won't be retained

    cell->_image = nil;
    cell->_title = nil;
    
    [cell set_image:[self _image]];
    [cell set_title:[self _title]];
    
    return cell;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect imageRect = [self imageRectForBounds:cellFrame];
    if (_image) {
        [_image drawInRect:imageRect 
                 fromRect:NSZeroRect 
                operation:NSCompositeSourceOver
                 fraction:1.0 
           respectFlipped:YES 
                    hints:nil];
    } else {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
        [[NSColor clearColor] set];
        [path fill];
    }
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    NSAttributedString *aTitle = [self attributedStringValue];
    if ([aTitle length] > 0) {
        [aTitle drawInRect:titleRect];
    }
    
    /*
    NSRect subtitleRect = [self subtitleRectForBounds:cellFrame forTitleBounds:titleRect];
    NSAttributedString *aSubtitle = [self attributedSubtitleValue];
    if ([aSubtitle length] > 0) {
        [aSubtitle drawInRect:subtitleRect];
    }*/
}

#define BORDER_SIZE 0
#define IMAGE_SIZE 30

- (NSRect)imageRectForBounds:(NSRect)bounds
{
    NSRect imageRect = bounds;
    
    imageRect.origin.x += BORDER_SIZE;
    imageRect.origin.y += BORDER_SIZE;
    imageRect.size.width = IMAGE_SIZE;
    imageRect.size.height = IMAGE_SIZE;
    
    return imageRect;
}

- (NSRect)titleRectForBounds:(NSRect)bounds
{
    NSRect titleRect = bounds;
    
    titleRect.origin.x += IMAGE_SIZE + (BORDER_SIZE * 2);
    titleRect.origin.y += BORDER_SIZE;
    
    NSAttributedString *title = [self attributedStringValue];
    if (title) {
        titleRect.size = [title size];
    } else {
        titleRect.size = NSZeroSize;
    }

    CGFloat maxX = NSMaxX(bounds);
    CGFloat maxWidth = maxX - NSMinX(titleRect);
    if (maxWidth < 0) {
        maxWidth = 0;
    }
    
    titleRect.size.width = MIN(NSWidth(titleRect), maxWidth);
    
    return titleRect;
    //self.controlView
}



@end

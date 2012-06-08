//
//  PspctFileTypeCell.h
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PspctFileTypeCell : NSTextFieldCell {
    
@private
    NSImage* _image;
    NSString* _title;
    
}

@property (readwrite, retain) NSImage* _image;
@property (readwrite, copy) NSString* _title;

@end

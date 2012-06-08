//
//  PspctContentController.h
//  Dashboard
//
//  Created by Robert Witoff on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpotlightSearch, PspctItemTable;

@interface PspctContentController : NSObject<NSTableViewDelegate, NSTableViewDataSource>{
    
@private
    IBOutlet NSWindow *_window;
    IBOutlet PspctItemTable *_tableView;
    SpotlightSearch *search;
    IBOutlet NSTableColumn *col0;
    IBOutlet NSTableColumn *col1;
    IBOutlet NSImageView *imgView;

}

-(IBAction)cellClick:(id)sender;

@end

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
    IBOutlet PspctItemTable *_tableView;
    SpotlightSearch *search;
    IBOutlet NSTableColumn *col0;
    IBOutlet NSTableColumn *col1;
    IBOutlet NSImageView *imgView;
    IBOutlet NSWindow *_window;

}

-(void)annotate:(NSInteger)row;
-(void)openFile:(NSInteger)row;
-(void)openFolder:(NSInteger)row;
-(void)deleteTag:(NSInteger)row;

-(NSArray*)getSelectedItems:(NSInteger)row;
-(NSString*)getDaggerForRow:(NSInteger)row;

@end

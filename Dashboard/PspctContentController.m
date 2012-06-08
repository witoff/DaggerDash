//
//  PspctContentController.m
//  Dashboard
//
//  Created by Robert Witoff on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctContentController.h"
#import "SpotlightSearch.h"
#import "PspctItemTable.h"
#import "RegexKitLite.h"
#import "PspctMetadataItem.h"
#import "PspctFileTypeCell.h"

@implementation PspctContentController

-(id)init{
    self = [super init];
    if (self)
    {
        search = [[SpotlightSearch alloc] init];
    }
    return self;
}


#pragma mark NSTableDelegate methods

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return ![self tableView:tableView isGroupRow:row];
    
    
    /*NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
     long column = [self columnAtPoint:point];
     long row = [self rowAtPoint:point];    */
}

-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}

-(void)awakeFromNib
{
    NSLog(@"awaken!");
    [search registerTableView:_tableView];
    [search startSearchAction:nil];
        
}



#pragma mark NSTableDataSource methods

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [search getGroupedResults].count;
    
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id obj = [[search getGroupedResults] objectAtIndex:row];
    
    // Manage Headers
    if ([self tableView:nil isGroupRow:row])
    {
        if (tableColumn ==col1)
            return obj;
        return @"";
    }
    
    // Data Cells
    PspctMetadataItem *item = (PspctMetadataItem*)obj;
    if (tableColumn==col0)
    {     
        return nil;
    }
    if (tableColumn==col1)
    {        
        NSString *name = [item getName];
        name = [name stringByReplacingOccurrencesOfString:@"†" withString:@""];
        //name = [name stringByReplacingOccurrencesOfRegex:@"†[a-z0-9]*" withString:@""];
        return name;
    }
    NSLog(@"bad column found");
    return nil;
}



-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableColumn==col0)
    {
        PspctFileTypeCell *imgCell = (PspctFileTypeCell*)cell;
        
        if ([self tableView:tableView isGroupRow:row]){
            [imgCell set_image:nil];
        }
        else {            
            PspctMetadataItem *item = [[search getGroupedResults] objectAtIndex:row];        
            NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[item getPath]];
            [imgCell set_image:img];
        }
    }
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    NSArray* array = [search getGroupedResults];
    id obj = [array objectAtIndex:row];
    
    BOOL isClass = ([obj isKindOfClass:[NSString class]]);
    return isClass;
}


-(IBAction)cellClick:(id)sender{
    
    
    NSLog(@"click!: %ld", [_tableView clickedRow]);
    
    int row = _tableView.clickedRow;
    
    if ([self tableView:nil isGroupRow:row])
        return;
    
    //Get the item
    PspctMetadataItem *item = [[search getGroupedResults] objectAtIndex:row];
    NSString *path = [item getPath];
    
    //Open the File
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [workspace openFile:path];
    
    
}

@end
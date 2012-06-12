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
#import "PspctTableCellView.h"

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
    return YES;//![self tableView:tableView isGroupRow:row];
}

- (NSArray *)allSubviewsOfView:(NSView *)view
{
    NSLog(@"called");
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (NSView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}

-(void)awakeFromNib {
    [search registerTableView:_tableView];
    [search startSearchAction:nil];
}



#pragma mark NSTableDataSource methods

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    //NSLog(@"number of rows: %ld", [search getGroupedResults].count);
    return [search getGroupedResults].count;
    
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    PspctTableCellView *cell = [tableView makeViewWithIdentifier:@"DashCell" owner:self];
    cell.controller = self;
    cell.row = row;
    
    id obj = [[search getGroupedResults] objectAtIndex:row];
    if ([self tableView:nil isGroupRow:row])
    {
        // Headers
        cell.textField.font = [NSFont systemFontOfSize:25.];
        cell.textField.stringValue = obj;
        cell.imageView.image = nil;
        
    }
    else {
        // Data Cells
        PspctMetadataItem *item = (PspctMetadataItem*)obj;
        
        cell.textField.font = [NSFont systemFontOfSize:14.];
        
        NSString *name = [[item getName] stringByDeletingPathExtension];
        name = [name stringByReplacingOccurrencesOfString:@"†" withString:@""];
        //name = [name stringByReplacingOccurrencesOfRegex:@"†[a-z0-9]*" withString:@""];
        cell.textField.stringValue = name;
        
        NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[item getPath]];
        cell.imageView.image = img;
        
    }
    return cell;
}


- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    NSArray* array = [search getGroupedResults];
    id obj = [array objectAtIndex:row];
    
    BOOL isClass = ([obj isKindOfClass:[NSString class]]);
    return isClass;
}


-(void)openFile:(NSInteger)row{    

    if ([self tableView:nil isGroupRow:row])
        [self hideAllWindows];
    
    for (PspctMetadataItem *item in [self getSelectedItems:row]) {
        NSString *path = [item getPath];
        
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        [workspace openFile:path];
    }
}

-(void)openFolder:(NSInteger)row
{
    if ([self tableView:nil isGroupRow:row])
        [self hideAllWindows];
    
    for (PspctMetadataItem *item in [self getSelectedItems:row]) {
        NSString *path = [item getPath];// stringByDeletingLastPathComponent];
        NSURL *url = [NSURL fileURLWithPath:path];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:qArray(url)];
    }
}

-(void)hideAllWindows
{    
    NSArray *apps = [NSArray arrayWithArray:[[NSWorkspace sharedWorkspace] runningApplications]];
    for (NSRunningApplication *app in apps ) {
        //Hide everything but this app
        if ([app.localizedName isEqualToString: [NSRunningApplication currentApplication].localizedName])
            continue;
        [app hide];
    }
    
    /*for (NSWindow *win in [NSApp windows]) {
     [NSApp hide:win];
     }*/
}


/* */
-(NSArray*)getSelectedItems:(NSInteger)row
{
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithCapacity:7];
    
    if ([self tableView:nil isGroupRow:row])
    {       
        NSInteger i = row+1;
        while (i<[self numberOfRowsInTableView:nil] && ![self tableView:nil isGroupRow:i])
        {
            PspctMetadataItem *item = [[search getGroupedResults] objectAtIndex:i];
            [allItems addObject:item];
            i++;
        }
    }
    else
    {
        PspctMetadataItem *item = [[search getGroupedResults] objectAtIndex:row];
        [allItems addObject:item];
    }
    
    return allItems;
}

-(NSString*)getDaggerForRow:(NSInteger)row
{
    NSString *dagger= nil;    
    if ([self tableView:nil isGroupRow:row])
        dagger= [[search getGroupedResults] objectAtIndex:row];
    else{
        //Get Section
        NSInteger i = row;
        while (![self tableView:nil isGroupRow:i])
            i--;
        dagger = [[search getGroupedResults] objectAtIndex:i];
    }
    return dagger;
}

-(void)deleteTag:(NSInteger)row
{
    NSLog(@"delete tag");
    NSArray* allItems = [self getSelectedItems:row];
    
    NSString *section = [self getDaggerForRow:row];
    
    for (PspctMetadataItem *item in allItems) {
        
        
        //Use the last path component so we don't rename special files whose 'names' aren't in the FS name
        NSString *name = [[item getPath] lastPathComponent];
        
        NSString *regex = [NSString stringWithFormat:@"†%@", section];
        NSString* newName = [name stringByReplacingOccurrencesOfRegex:regex withString:section];
        
        //rename it
        NSString *oldPath = [item getPath];
        NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
        
        NSLog(@"oldPath: %@", oldPath);
        NSLog(@"newPath: %@", newPath);
        if ([oldPath isEqualToString:newPath])
        {
            NSLog(@"path could not be changed");
            //TODO: Hide!
        }
        else
            [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
    }
}

@end
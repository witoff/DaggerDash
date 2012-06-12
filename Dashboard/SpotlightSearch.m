//
//  SpotlightSearch.m
//  Dashboard
//
//  Created by Robert Witoff on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpotlightSearch.h"
#import "RegexKitLite.h"
#import "PspctMetadataItem.h"

@interface SpotlightSearch (hidden)

-(void)processNewResults:(NSTimer*)aTimer;

-(NSArray*)getFilteredResults;
-(void)publishNewData:(NSArray*)results;
-(void)groupAndFlattenResults:(NSArray*)results;


@end

@implementation SpotlightSearch

-(id)init{
    self = [super init];
    if (self) {
        _query = [[NSMetadataQuery alloc] init];
        _tableView = nil;
        _lastCount = 0;
        _groupedResults = nil;
    }
    return self;
}

-(void)registerTableView:(NSTableView*)view; {
    _tableView = view;
}

#pragma mark timing

- (IBAction)startSearchAction:(id)sender {
    if ([_query isStarted]) {
        //logDebug(@"already started");
        return;
    }
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"kMDItemDisplayName LIKE '*†*'", nil];
    
    [_query setPredicate:p];
    // [_query setSearchScopes: [NSArray arrayWithObject:@"/Users/Rob/BnB/"]];
    
    if ([_query startQuery]) {
        _timer = 
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self 
                                       selector:@selector(processNewResults:) 
                                       userInfo:_query
                                        repeats:YES];
        //NSRunLoop retains the timer
        [[NSRunLoop currentRunLoop] 
         addTimer:_timer
         forMode:NSDefaultRunLoopMode];
    }
    else {
        NSLog(@"Error. Could not start query. Weird.");
    }
}

- (IBAction)stopSearchAction:(id)sender
{
    [self stopSearching];
    
}

//called via the NSMetadataQueryDidFinishGatheringNotification 
//and/or the stopSearchAction: method
- (void)stopSearching 
{
    //don't invalidate a timer more than once
    if (!([_query isStopped]))
    {
        [_query stopQuery];
        [_timer invalidate];
    }
}

#pragma mark data management

/* If query results have changed, then publish the updates */
- (void)processNewResults:(NSTimer*)aTimer
{
    NSArray *results = [self getFilteredResults];
    
    if (_lastCount != results.count) {
        [self publishNewData:results];
        return;
    }
    
    for (NSMetadataItem *newItem in results) {        
        
        //Object Matching
        BOOL found = NO;
        for (id oldItem in _groupedResults) {
            if ([oldItem isKindOfClass:[PspctMetadataItem class]]) {
                if ( [(PspctMetadataItem*)oldItem getItem] == newItem) {
                    //Check for changed names
                    if (![(PspctMetadataItem*)oldItem hasNameChanged]) {
                        found = YES;
                    }
                    else
                        NSLog(@"name change");
                    break;
                    
                }
            }
        }
        
        if (!found)
        {
            [self publishNewData:results];
            return;                
        }
    }
    
    //for (NSMetadataItem* item in query.results) {
    //NSLog(@"kMDItemFSName: %@", [item valueForAttribute:@"kMDItemFSName"]);
    
    /*
     kMDItemContentTypeTree,
     kMDItemSupportFileType,
     kMDItemContentType,
     kMDItemPhysicalSize,
     kMDItemKind,
     kMDItemDisplayName,
     kMDItemContentModificationDate,
     kMDItemContentCreationDate,
     kMDItemDateAdded,
     kMDItemLogicalSize,
     kMDItemFSName,
     kMDItemFSSize,
     kMDItemFSCreationDate,
     kMDItemFSContentChangeDate,
     kMDItemFSOwnerUserID,
     kMDItemFSOwnerGroupID,
     kMDItemFSNodeCount,
     kMDItemFSInvisible,
     kMDItemFSTypeCode,
     kMDItemFSCreatorCode,
     kMDItemFSFinderFlags,
     kMDItemFSHasCustomIcon,
     kMDItemFSIsExtensionHidden,
     kMDItemFSIsStationery,
     kMDItemFSLabel
     */
    //}
    
}

-(NSArray*)getFilteredResults
{
    //Check to see if anything has changed
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:_query.results.count];
    
    //Ignore files in the trash
    NSArray *ignorePaths = qArray(@".Trash", [NSString pathWithComponents:qArray(@"Safari", @"History")]);
    for(NSMetadataItem *item in _query.results)
    {
        BOOL skip = NO;
        for (NSString* path in ignorePaths) {
            if ([[item valueForAttribute:(NSString*)kMDItemPath] rangeOfString:path].location!=NSNotFound)
            {
                skip=YES;
                break;
            }
        }
        if (!skip)
            [results addObject:item];
    }
    return results;
}

-(void)publishNewData:(NSArray*)results
{
    _lastCount = results.count;
    NSLog(@"refreshing data!");
    [self groupAndFlattenResults:results];
    
    if (_tableView)
        [_tableView reloadData];
}

-(void)groupAndFlattenResults:(NSArray*)results;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];    
    
    for (NSMetadataItem *item in results) {
        PspctMetadataItem *mdItem = [[PspctMetadataItem alloc] initWithItem:item];
        
        NSArray *daggers = [mdItem getDaggers];
        
        for (NSArray *set in daggers) {
            
            NSString *m = [set objectAtIndex:1];
            
            if ([dict objectForKey:m])
            {
                NSMutableArray* entries = (NSMutableArray*)[dict objectForKey:m];
                [entries addObject:mdItem];
            }
            else {
                NSMutableArray* entries = [[NSMutableArray alloc] initWithCapacity:5];
                [entries addObject:mdItem];
                [dict setObject:entries forKey:m];
            }
        }
    }
    
    //Flatten
    NSMutableArray *flattened = [[NSMutableArray alloc] initWithCapacity:(dict.count + results.count)];
    for (NSString *key in dict.keyEnumerator) {
        [flattened addObject:key];
        [flattened addObjectsFromArray:[dict objectForKey:key]];
    }
    
    _groupedResults = flattened;
}

-(NSArray*)getGroupedResults
{
    return _groupedResults;
}

@end

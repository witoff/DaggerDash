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

@implementation SpotlightSearch

@synthesize flattenedResults;

-(id)init{
    self = [super init];
    if (self)
    {
        query = [[NSMetadataQuery alloc] init];
        _tableView = nil;
        _lastCount = 0;
        flattenedResults = nil;
        
    }
    return self;
}

- (IBAction)startSearchAction:(id)sender
{
    //whatever query you want. emlx corresponds 
    //to mail messages. you could easily
    //configure search terms from user interaction.
    NSPredicate *p = 
    [NSPredicate predicateWithFormat:@"kMDItemDisplayName like '*†*'", nil];
    [query setPredicate:p];
    
    //optionally set search scopes
    //[q setSearchScopes:
    //    [NSArray arrayWithObject:@"/Users/matthew/Library/Mail/"]];
    
    //start the query and use the run loop 
    //to process the search progress.
    if ([query startQuery])
    {
        timer = 
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self 
                                       selector:@selector(updateResults:) 
                                       userInfo:query
                                        repeats:YES];
        
        //NSRunLoop retains the timer
        [[NSRunLoop currentRunLoop] 
         addTimer:timer
         forMode:NSDefaultRunLoopMode];
    }
    else
    {
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
    if (!([query isStopped]))
    {
        //NSLog(@"Finito. Num results = %d", [q resultCount]);
        [self updateResults:timer];
        [query stopQuery];
        [timer invalidate];
    }
}

-(void)refreshData
{
    _lastCount = query.results.count;
    NSLog(@"refreshing data!");
    [self groupResults];
    [_tableView reloadData];
    
}

- (void)updateResults:(NSTimer*)aTimer
{
    if (_lastCount != query.results.count)
    {
        [self refreshData];
        return;
    }
    
    for (NSMetadataItem *newItem in query.results) {        
        
        //Object Matching
        BOOL found = NO;
        for (id oldItem in self.flattenedResults)
        {
            if ([oldItem isKindOfClass:[PspctMetadataItem class]])
            {
                if ( [(PspctMetadataItem*)oldItem getItem] == newItem)
                {
                    //Check for changed names
                    if (![(PspctMetadataItem*)oldItem hasNameChanged])
                    {
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
            [self refreshData];
            return;                
        }
    }
    
    
    //for (NSMetadataItem* item in query.results) {
    //NSLog(@"kMDItemFSName: %@", [item valueForAttribute:@"kMDItemFSName"]);
    //NSLog(@"kMDItemDisplayName: %@", [item valueForAttribute:(NSString*)kMDItemPath]);
    
    //NSLog(@"kMDItemFSLabel: %@", [item valueForAttribute:@"kMDItemFSLabel"]);
    
    
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
    //[aTimer invalidate];
    
}

-(NSUInteger)getResultCount
{
    return query.resultCount;
}

-(NSMetadataItem*)getResultAtIndex:(NSUInteger)index
{
    if (index<query.results.count)
    {
        NSMetadataItem *item = [query resultAtIndex:index];
        return item;
    }
    return nil;
}

-(NSArray*)getGroupedResults
{
    return self.flattenedResults;
}

-(void)groupResults;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *name1 = @"testy testerst.rtf";
    NSString *str1 = [name1 stringByMatching:@"([a-z]).*rtf" capture:0];
    NSLog(@"TEST: %@", str1);
    
    
    for (NSMetadataItem *item in query.results) {
        PspctMetadataItem *mdItem = [[PspctMetadataItem alloc] initWithItem:item];
        
        NSString *name = [mdItem getName];
        NSArray *matches = [name arrayOfCaptureComponentsMatchedByRegex:@"†([a-zA-Z0-9]*)"];
        
        for (NSArray *set in matches) {
            
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
    NSMutableArray *flattened = [[NSMutableArray alloc] initWithCapacity:(dict.count +  query.resultCount)];
    for (NSString *key in dict.keyEnumerator) {
        [flattened addObject:key];
        [flattened addObjectsFromArray:[dict objectForKey:key]];
    }
    
    self.flattenedResults = flattened;
}

-(NSString*)getResultNameAtIndex:(NSUInteger)index
{
    if (index<query.results.count)
    {
        NSMetadataItem *item = [query resultAtIndex:index];
        NSString* name = [item valueForAttribute:(NSString*)kMDItemDisplayName];
        return name;
    }
    return nil;
}

-(void)registerTableView:(NSTableView*)view;
{
    _tableView = view;
}

@end

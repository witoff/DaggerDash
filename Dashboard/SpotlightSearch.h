//
//  SpotlightSearch.h
//  Dashboard
//
//  Created by Robert Witoff on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotlightSearch : NSObject
{
    NSMetadataQuery *query;
    NSTimer *timer;
    NSArray *flattenedResults;
    
@private
    NSTableView* _tableView;
    int _lastCount;
}

@property (nonatomic, retain) NSArray *flattenedResults;

- (IBAction)startSearchAction:(id)sender;
- (IBAction)stopSearchAction:(id)sender;

-(NSUInteger)getResultCount;
-(NSArray*)getGroupedResults;
-(NSMetadataItem*)getResultAtIndex:(NSUInteger)index;
-(NSString*)getResultNameAtIndex:(NSUInteger)index;
-(void)registerTableView:(NSTableView*)view;

-(void)groupResults;

@end

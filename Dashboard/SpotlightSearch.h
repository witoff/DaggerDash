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

@private    
    NSMetadataQuery *_query;
    NSTimer *_timer;
    
    NSArray *_groupedResults;
    NSTableView* _tableView;
    int _lastCount;
}

- (IBAction)startSearchAction:(id)sender;
- (IBAction)stopSearchAction:(id)sender;

/* grouped with section headersresults */
-(NSArray*)getGroupedResults;

/* a reload message will be sent to this tableview whenever search results change */
-(void)registerTableView:(NSTableView*)view;

@end

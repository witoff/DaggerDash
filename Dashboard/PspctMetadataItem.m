//
//  PspctMetadataItem.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctMetadataItem.h"

@implementation PspctMetadataItem

@synthesize _item, _initialName;

-(id)initWithItem:(NSMetadataItem*)item
{
    self = [super init];
    if (self)
    {
        self._item = item;
        self._initialName = [self getName];
    }
    return self;
}


-(NSString*)getInitialName
{
    return _initialName;
}
-(NSString*)getName
{
    return [_item valueForAttribute:(NSString*)kMDItemDisplayName];
}

-(NSMetadataItem*)getItem
{
    return self._item;
}

-(BOOL)hasNameChanged
{
    return ![[self getInitialName] isEqualToString:[self getName]];
}


-(NSString*)getPath{
    return [_item valueForAttribute:(NSString*)kMDItemPath];
}

-(NSString*)getType{
    return [_item valueForAttribute:(NSString*)kMDItemKind];
}

@end

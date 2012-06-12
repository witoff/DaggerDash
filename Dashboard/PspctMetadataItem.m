//
//  PspctMetadataItem.m
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctMetadataItem.h"
#import "RegexKitLite.h"

@implementation PspctMetadataItem

@synthesize _item, _initialName;

-(id)initWithItem:(NSMetadataItem*)item
{
    self = [super init];
    if (self)
    {
        self._item = item;
        self._initialName = [self getRawName];
    }
    return self;
}


-(NSString*)getInitialName
{
    return _initialName;
}

-(NSString*)getRawName{
    return [_item valueForAttribute:(NSString*)kMDItemDisplayName];
}

-(NSString*)getName
{
    //Remove Extension
    //NSLog(@"raw name: %@", [self getRawName]);
    NSString *name = [[_item valueForAttribute:(NSString*)kMDItemDisplayName] stringByDeletingPathExtension];
    
    //Remove trailing daggers
    //name = [name stringByReplacingOccurrencesOfRegex:@"(†[a-zA-Z0-0]\\s*)$" withString:@""];
    if (![[name substringToIndex:1] isEqualToString:@"†"] )
        name = [name stringByReplacingOccurrencesOfRegex:@"(?:†\\S+\\s*)+$" withString:@""];
    //NSLog(@"fin name: %@", name);
    return name;
}

-(NSArray*)getDaggers
{
    NSArray *daggers = [[self getRawName] arrayOfCaptureComponentsMatchedByRegex:@"†([a-zA-Z0-9]*)"];
    return daggers;
}

-(NSMetadataItem*)getItem
{
    return self._item;
}

-(BOOL)hasNameChanged
{
    return ![[self getInitialName] isEqualToString:[self getRawName]];
}


-(NSString*)getPath{
    return [_item valueForAttribute:(NSString*)kMDItemPath];
}

-(NSString*)getType{
    return [_item valueForAttribute:(NSString*)kMDItemKind];
}

@end

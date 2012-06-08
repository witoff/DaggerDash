//
//  PspctMetadataItem.h
//  Dashboard
//
//  Created by Robert Witoff on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PspctMetadataItem : NSObject
{
@private
    NSMetadataItem* _item;
    NSString* _initialName;
}

@property (nonatomic, retain) NSMetadataItem *_item;
@property (nonatomic, retain) NSString *_initialName;

-(id)initWithItem:(NSMetadataItem*)item;

-(NSMetadataItem*)getItem;

-(NSString*)getInitialName;

-(NSString*)getName;
-(NSString*)getPath;
-(NSString*)getType;
    
-(BOOL)hasNameChanged;

@end

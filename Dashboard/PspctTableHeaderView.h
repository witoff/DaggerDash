//
//  PspctTableHeaderView.h
//  DaggerDash
//
//  Created by Robert Witoff on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PspctTableCellView.h"

@interface PspctTableHeaderView : PspctTableCellView<NSTextFieldDelegate>{
    NSTextView *textView;
    NSTextField *commentText;
}

@property(nonatomic, retain) IBOutlet NSTextField* commentText;
@property(nonatomic, retain) IBOutlet NSTextView* textView;

@end

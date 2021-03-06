//
//  PspctAppDelegate.h
//  Dashboard
//
//  Created by Robert Witoff on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PspctAppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;    
    
    NSMutableDictionary *daggerComments;
}

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSMutableDictionary *daggerComments;

- (IBAction)saveAction:(id)sender;
- (IBAction)menuClick:(id)sender;
- (void) registerShortcut;
-(void)saveComments;

@end

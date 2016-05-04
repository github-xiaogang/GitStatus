//
//  AppDelegate.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "AppDelegate.h"
#import "TestUtil.h"
#import "RepoWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) RepoWindowController * repoWC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    /*
    [TestUtil setup];
    [TestUtil test];
     */
    [self doMainRoutine];
}

- (void)doMainRoutine
{
    RepoWindowController * repoWC = [[RepoWindowController alloc] initWithWindowNibName:@"RepoWindowController"];
    self.repoWC = repoWC;
    [repoWC showWindow:nil];
    [repoWC.window makeMainWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

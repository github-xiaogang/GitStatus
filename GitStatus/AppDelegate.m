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
#import "StatusMonitor.h"
#import "Preference.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) RepoWindowController * repoWC;
@property (nonatomic, strong) NSStatusItem * cleanItem;
@property (nonatomic, strong) NSStatusItem * safeItem;

@property (nonatomic, strong) StatusMonitor * repoMonitor;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupStatusMenu];
    StatusMonitor * monitor = [StatusMonitor sharedMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRepoStatusUpdated) name:kStatusMonitorRepoUpdatedNotification object:monitor];
    self.repoMonitor = monitor;
    [self updateRepoStatusUI];
    [self.repoMonitor start];
}

- (void)setupStatusMenu
{
    NSStatusBar * statusBar = [NSStatusBar systemStatusBar];
    NSStatusItem * cleanItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    NSButton * cleanButton = cleanItem.button;
    [cleanButton setTarget:self];
    [cleanButton setAction:@selector(cleanItemClicked:)];
    NSStatusItem * safeItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    NSButton * safeButton = safeItem.button;
    [safeButton setTarget:self];
    [safeButton setAction:@selector(safeItemClicked:)];
    self.cleanItem = cleanItem;
    self.safeItem = safeItem;
}

- (void)doRepoStatusUpdated
{
    [self updateRepoStatusUI];
}

- (void)updateRepoStatusUI
{
    BOOL isClean = self.repoMonitor.isClean;
    BOOL isSafe = self.repoMonitor.isSafe;
    NSButton * cleanButton = self.cleanItem.button;
    NSButton * safeButton = self.safeItem.button;
    if(isClean){
        [cleanButton setImage:[NSImage imageNamed:@"clean"]];
    }else{
        [cleanButton setImage:[NSImage imageNamed:@"unclean"]];
    }
    if(isSafe){
        [safeButton setImage:[NSImage imageNamed:@"safe"]];
    }else{
        [safeButton setImage:[NSImage imageNamed:@"unsafe"]];
    }
}

- (void)doMainRoutine
{
    RepoWindowController * repoWC = [[RepoWindowController alloc] initWithWindowNibName:@"RepoWindowController"];
    self.repoWC = repoWC;
    [repoWC showWindow:nil];
    [repoWC.window makeMainWindow];
    [repoWC.window orderFrontRegardless];
}

- (void)cleanItemClicked: (NSButton *)button
{
    [self doMainRoutine];
}

- (void)safeItemClicked: (NSButton *)button
{
    [self doMainRoutine];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end





























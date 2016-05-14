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
#import "PreferenceWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) RepoWindowController * repoWC;
@property (nonatomic, strong) PreferenceWindowController * preferenceWC;
@property (nonatomic, strong) NSStatusItem * statusItem;
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
    NSStatusItem * statusItem = [statusBar statusItemWithLength:44.0f];
    NSButton * statusButton = statusItem.button;
    [statusButton setTarget:self];
    [statusButton setAction:@selector(cleanItemClicked:)];
    self.statusItem = statusItem;
}

- (void)doRepoStatusUpdated
{
    [self updateRepoStatusUI];
}

- (void)updateRepoStatusUI
{
    BOOL isSafe = self.repoMonitor.isSafe;
    BOOL isClean = self.repoMonitor.isClean;
    NSString * statusTip = @"";
    NSButton * statusButton = self.statusItem.button;
    if(!isSafe){
        NSMutableString * tip = [NSMutableString string];
        NSArray * unsafeList = self.repoMonitor.unsafeList;
        for (int i=0;i<unsafeList.count;i++) {
            Repository * repo = unsafeList[i];
            if(i != unsafeList.count-1){
                [tip appendFormat:@"%@,",repo.name];
            }else{
                [tip appendFormat:@"%@ ",repo.name];
            }
        }
        [tip appendString:@"unsafe"];
        statusTip = [NSString stringWithFormat:@"%@%@",statusTip,tip];
    }
    if(!isClean){
        NSMutableString * tip = [NSMutableString string];
        NSArray * uncleanList = self.repoMonitor.uncleanList;
        for (int i=0;i<uncleanList.count;i++) {
            Repository * repo = uncleanList[i];
            if(i != uncleanList.count-1){
                [tip appendFormat:@"%@,",repo.name];
            }else{
                [tip appendFormat:@"%@ ",repo.name];
            }
        }
        [tip appendString:@"unclean"];
        if(statusTip.length > 0){
            statusTip = [NSString stringWithFormat:@"%@\n",statusTip];
        }
        statusTip = [NSString stringWithFormat:@"%@%@",statusTip,tip];
    }
    [statusButton setToolTip:statusTip];
    NSString * statusIcon = nil;
    NSString * safe = isSafe ? @"safe" : @"unsafe";
    NSString * clean = isClean ? @"clean" : @"unclean";
    statusIcon = [NSString stringWithFormat:@"%@_%@",safe,clean];
    [statusButton setImage:[NSImage imageNamed:statusIcon]];
}

- (void)doMainRoutine
{
    if(!self.repoWC){
        RepoWindowController * repoWC = [[RepoWindowController alloc] initWithWindowNibName:@"RepoWindowController"];
        self.repoWC = repoWC;
    }else{
        [self.repoWC update];
    }
    [self.repoWC showWindow:nil];
    [self.repoWC.window makeMainWindow];
    [self.repoWC.window orderFrontRegardless];
}

- (void)cleanItemClicked: (NSButton *)button
{
    [self doMainRoutine];
}

- (void)safeItemClicked: (NSButton *)button
{
    [self doMainRoutine];
}

- (IBAction)preferenceMenuPressed:(id)sender {
    PreferenceWindowController * preferenceWC = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindowController"];
    self.preferenceWC = preferenceWC;
    [preferenceWC showWindow:nil];
    [preferenceWC.window makeMainWindow];
    [preferenceWC.window orderFrontRegardless];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end





























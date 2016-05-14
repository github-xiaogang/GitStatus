//
//  PreferenceWindowController.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/13.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "PreferenceWindowController.h"
#import "Preference.h"

@import CoreServices;

@interface PreferenceWindowController ()

@property (weak) IBOutlet NSButton *startupButton;
@property (weak) IBOutlet NSTextField *clientTextfield;

@end

@implementation PreferenceWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    BOOL launchAtStartup = [Preference isLaunchAtStartup];
    self.startupButton.state = launchAtStartup ? 1 : 0;
    self.clientTextfield.stringValue = [Preference gitClient];
}

- (IBAction)startupButtonPressed:(id)sender {
    if(self.startupButton.state == 1){
        [Preference setLaunchAtStartup:YES];
    }else{
        [Preference setLaunchAtStartup:NO];
    }
}

- (IBAction)editButtonPressed:(id)sender {
    NSString * client = self.clientTextfield.stringValue;
    [Preference setGitClient:client];
    NSAlert * alert = [[NSAlert alloc] init];
    [alert setMessageText:@"edit success"];
    [alert runModal];
}

@end
























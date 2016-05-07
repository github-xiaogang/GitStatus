//
//  RepoAddViewController.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "RepoAddWindowController.h"
#import "RepoUtil.h"

@interface RepoAddWindowController ()

@property (weak) IBOutlet NSTextField *repoPathTextfield;
@property (weak) IBOutlet NSTextField *nameTextfield;


@end

@implementation RepoAddWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.title = @"Add Repo";
}

- (IBAction)cancelButtonPressed:(id)sender {
    if(self.cancelBlock){
        self.cancelBlock();
    }
}

- (IBAction)addButtonPressed:(id)sender {
    NSString * repoPath = self.repoPathTextfield.stringValue;
    NSString * repoName = self.nameTextfield.stringValue;
    
    if(![GitUtil validateRepo:repoPath]) return;
    if(repoName.length == 0) return;
    
    RepoUtil * repoUtil = [RepoUtil sharedUtil];
    [repoUtil addRepoWithName:repoName andPath:repoPath];
    if(self.completionBlock){
        self.completionBlock();
    }
}
@end

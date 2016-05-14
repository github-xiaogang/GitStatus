//
//  RepoWindowController.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "RepoWindowController.h"
#import "RepoCellView.h"
#import "RepoUtil.h"
#import "RepoAddWindowController.h"
#import "BranchWindowController.h"
#import "StatusMonitor.h"
#import "Preference.h"

@interface RepoWindowController ()<RepoCellViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSArray * repoList;
@property (nonatomic, strong) RepoAddWindowController * repoAddWC;
@property (nonatomic, strong) BranchWindowController * branchWC;

@end

@implementation RepoWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.title = @"Git Status";
    [self.window center];
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kRepoUtilRepoUpdatedNotification object:nil];
}

- (void)update
{
    [self reloadData];
}

#pragma mark -----------------   table view datasource & delegate   ----------------
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.repoList.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return [RepoCellView preferedHeight];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    RepoCellView * cell = [tableView makeViewWithIdentifier:NSStringFromClass([RepoCellView class]) owner:self];
    if(cell == nil){
        cell = [RepoCellView newInstance];
    }
    cell.delegate = self;
    [cell setData: self.repoList[row]];
    return cell;
}

- (IBAction)repoAddButtonPressed:(id)sender {
    RepoAddWindowController * repoAddWC = [[RepoAddWindowController alloc] initWithWindowNibName:@"RepoAddWindowController"];
    self.repoAddWC = repoAddWC;
    [self.repoAddWC showWindow:nil];
    __block typeof(self) wself = self;
    [repoAddWC setCompletionBlock:^{
        [wself reloadData];
        [wself.repoAddWC.window close];
    }];
    [repoAddWC setCancelBlock:^{
        [wself.repoAddWC.window close];
    }];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self reloadData];
}


#pragma mark -----------------   cell delegate   ----------------
- (void)repoCellViewSelected: (RepoCellView *)repoCellView
{
    NSString * gitClient = [Preference gitClient];
    if(gitClient.length > 0){
        [[NSWorkspace sharedWorkspace] launchApplication:gitClient];
    }
}

- (void)repoCellBranchSelected:(RepoCellView *)repoCellView
{
    NSInteger row = [self.tableView rowForView:repoCellView];
    Repository * repo = self.repoList[row];
    BranchWindowController * branchWC = [[BranchWindowController alloc] initWithWindowNibName:@"BranchWindowController"];
    branchWC.repo = repo;
    self.branchWC = branchWC;
    [self.branchWC showWindow:nil];
}

- (void)reloadData
{
    [[RepoUtil sharedUtil] asyncLoadRepoList:^(NSArray *repoList) {
        self.repoList = repoList;
        [self.tableView reloadData];
    }];
}

@end








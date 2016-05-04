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

@interface RepoWindowController ()<RepoCellViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSArray * repoList;
@property (nonatomic, strong) RepoAddWindowController * repoAddWC;

@end

@implementation RepoWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
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

#pragma mark -----------------   cell delegate   ----------------
- (void)repoCellViewSelected: (RepoCellView *)repoCellView
{
    NSInteger row = [self.tableView rowForView:repoCellView];
}

- (void)reloadData
{
    self.repoList = [[RepoUtil sharedUtil] repoList];
    [self.tableView reloadData];
}

@end








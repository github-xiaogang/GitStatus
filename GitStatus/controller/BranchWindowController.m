//
//  BranchWindowController.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "BranchWindowController.h"
#import "BranchCellView.h"
#import "RepoUtil.h"

@interface BranchWindowController ()<BranchCellViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSArray * branchList;

@end

@implementation BranchWindowController


- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    self.branchList = self.repo.branchList;
}

#pragma mark -----------------   table view datasource & delegate   ----------------
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.branchList.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return [BranchCellView preferedHeight];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    BranchCellView * cell = [tableView makeViewWithIdentifier:NSStringFromClass([BranchCellView class]) owner:self];
    if(cell == nil){
        cell = [BranchCellView newInstance];
    }
    cell.delegate = self;
    [cell setData: self.branchList[row]];
    return cell;
}


#pragma mark -----------------   cell delegate   ----------------

- (void)branchCellView: (BranchCellView *)branchCellView branchChecked: (BOOL)checked
{
    NSInteger row = [self.tableView rowForView:branchCellView];
    Branch * branch = self.branchList[row];
    branch.stable = checked;
    [branchCellView setData:branch];
    RepoUtil * repoUtil = [RepoUtil sharedUtil];
    NSString * repoName = self.repo.name;
    NSString * branchName = branch.name;
    if(checked){
        [repoUtil addStableBranchWithRepoName:repoName branchName:branchName];
    }else{
        [repoUtil removeStableBranchWithRepoName:repoName branchName:branchName];
    }
}




@end










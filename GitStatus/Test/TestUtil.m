//
//  TestUtil.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "TestUtil.h"
#import "RepoUtil.h"

@implementation TestUtil

+ (void)setup
{
    [[GitUtil sharedUtil]  setCurrentRepo:@"/Users/zhangxiaogang/SourceTree/NewYear"];
}

+ (void)test
{
//    [self testBranchList];
//    [self testCurrentBranch];
//    [self testRepoClean];
//    [self testRepoList];
//    [self testRepoAdd];
//    [self testRepoRemove];
//    [self testStableBranchAdd];
    [self testStableBranchRemove];
}

+ (void)testBranchList
{
    NSArray * branchList = [[GitUtil sharedUtil] branchList];
    NSLog(@"%@",branchList);
}

+ (void)testCurrentBranch
{
    NSString * currentBranch = [[GitUtil sharedUtil] currentBranch];
    NSLog(@"current :%@",currentBranch);
}

+ (void)testRepoClean
{
    BOOL result = [[GitUtil sharedUtil] isRepoClean];
    NSLog(@"repo clean:%@",result ? @"CLEAN":@"NOT CLEAN");
}

 
+ (void)testRepoList
{
    NSArray * repoList = [[RepoUtil sharedUtil] repoList];
    NSLog(@"%@",repoList);
}

+ (void)testRepoAdd
{
    NSString * repoName = @"NewYear";
    NSString * repoPath = @"/Users/zhangxiaogang/SourceTree/NewYear";
    [[RepoUtil sharedUtil] addRepoWithName:repoName andPath:repoPath];
}

+ (void)testRepoRemove
{
    NSString * repoName = @"NewYear";
    [[RepoUtil sharedUtil] removeRepoWithName:repoName];
}

+ (void)testStableBranchAdd
{
    NSString * repoName = @"NewYear";
    NSString * stableBranch = @"master";
    [[RepoUtil sharedUtil] addStableBranchWithRepoName:repoName branchName:stableBranch];
}

+ (void)testStableBranchRemove
{
    NSString * repoName = @"NewYear";
    NSString * stableBranch = @"master";
    [[RepoUtil sharedUtil] removeStableBranchWithRepoName:repoName branchName:stableBranch];
}

@end










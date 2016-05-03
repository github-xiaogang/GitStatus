//
//  GitUtil.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "GitUtil.h"

static NSString * const kGitCmdBranchList = @"git branch";
static NSString * const kGitCmdRepoStatus = @"git status";

static NSString * const kOtherBranchNamePrefix = @"  ";
static NSString * const kCurrentBranchNamePrefix = @"* ";

static NSString * const kRepoCleanIdentityContent = @"nothing to commit, working directory clean";

@interface GitUtil ()

@property (nonatomic, strong) NSString * workingRepoPath;

@end

@implementation GitUtil

+ (GitUtil *)sharedUtil
{
    static GitUtil * sharedUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtil = [[GitUtil alloc] init];
    });
    return sharedUtil;
}

+ (BOOL)validateRepo: (NSString *)repoPath;
{
    BOOL result = NO;
    if([FileUtil dirExists:repoPath]){
        NSString * gitDir = [repoPath stringByAppendingPathComponent:@".git"];
        if([FileUtil dirExists:gitDir]){
            result = YES;
        }
    }
    return result;
}

- (BOOL)setCurrentRepo: (NSString *)repoPath
{
    BOOL result = NO;
    self.workingRepoPath = nil;
    if([GitUtil validateRepo:repoPath]){
        self.workingRepoPath = repoPath;
        result = YES;
    }
    return result;
}

- (NSString *)currentRepo
{
    return self.workingRepoPath;
}

- (NSArray *)branchList
{
    NSString * result = [CmdUtil runCmd:kGitCmdBranchList workPath:self.workingRepoPath];
    NSArray * branches = [result componentsSeparatedByString:@"\n"];
    NSMutableArray * branchList = [NSMutableArray array];
    for (NSString * branch in branches) {
        if(branch.length == 0) continue;
        if([branch hasPrefix:kCurrentBranchNamePrefix]){
            NSString * result = [branch substringFromIndex:kCurrentBranchNamePrefix.length];
            [branchList addObject:result];
        }else if([branch hasPrefix:kOtherBranchNamePrefix]){
            NSString * result = [branch substringFromIndex:kOtherBranchNamePrefix.length];
            [branchList addObject:result];
        }
    }
    return [NSArray arrayWithArray:branchList];
}

- (NSString *)currentBranch
{
    NSString * result = [CmdUtil runCmd:kGitCmdBranchList workPath:self.workingRepoPath];
    NSArray * branches = [result componentsSeparatedByString:@"\n"];
    NSString * currentBranch = nil;
    for (NSString * branch in branches) {
        if(branch.length == 0) continue;
        if([branch hasPrefix:kCurrentBranchNamePrefix]){
            currentBranch = [branch substringFromIndex:kCurrentBranchNamePrefix.length];
        }
    }
    return currentBranch;
}

- (BOOL)isRepoClean
{
    BOOL ret = NO;
    NSString * result = [CmdUtil runCmd:kGitCmdRepoStatus workPath:self.workingRepoPath];
    if([result rangeOfString:kRepoCleanIdentityContent].location != NSNotFound){
        ret = YES;
    }
    return ret;
}

@end























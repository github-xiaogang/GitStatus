//
//  RepoUtil.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "RepoUtil.h"


static NSString * const kRepoConfigFileName = @"repo.plist";

static NSString * const kRepoNameKey = @"name";
static NSString * const kRepoCreateTimeKey = @"createTime";
static NSString * const kRepoPathKey = @"repoPath";
static NSString * const kRepoStableListKey = @"stableList";

NSString * const kRepoUtilRepoUpdatedNotification = @"kRepoUtilRepoUpdatedNotification";

@interface RepoUtil ()

@property (nonatomic, strong) NSArray * repoConfigList;

@end

@implementation RepoUtil

+ (RepoUtil *)sharedUtil
{
    static RepoUtil * sharedUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtil = [[RepoUtil alloc] init];
    });
    return sharedUtil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadRepoConfig];
    }
    return self;
}

- (void)loadRepoConfig
{
    NSString * repoConfigPath = [self repoConfigPath];
    NSArray * configList = [NSArray arrayWithContentsOfFile:repoConfigPath];
    self.repoConfigList = configList;
}

- (void)asyncLoadRepoList: (RepoLoadCallback)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * repoList = [self repoList];
        dispatch_sync(dispatch_get_main_queue(), ^{
            callback(repoList);
        });
    });
}

- (NSArray *)repoList
{
    NSMutableArray * repoList = [NSMutableArray array];
    for (NSDictionary * data in self.repoConfigList) {
        NSString * name = data[kRepoNameKey];
        NSTimeInterval creatTime = [data[kRepoCreateTimeKey] doubleValue];
        NSString * repoPath = data[kRepoPathKey];
        NSArray * stableList = data[kRepoStableListKey];
        GitUtil * gitUtil = [GitUtil sharedUtil];
        if(![gitUtil setCurrentRepo:repoPath]) continue;
        NSString * currentBranch = nil;
        NSArray * branches = [gitUtil branchListAndCurrentBranch:&currentBranch];
        BOOL isRepoClean = [gitUtil isRepoClean];
        
        Repository * repo = [[Repository alloc] init];
        repo.name = name;
        repo.creatTime = creatTime;
        repo.clean = isRepoClean;
        NSMutableArray * branchList = [NSMutableArray array];
        for (NSString * branchName in branches) {
            Branch * branch = [[Branch alloc] init];
            branch.name = branchName;
            BOOL isCurrent = [branchName isEqualToString:currentBranch];
            BOOL isStable = NO;
            for (NSString * stableBranchName in stableList) {
                if([stableBranchName isEqualToString:branchName]){
                    isStable = YES;
                    break;
                }
            }
            branch.current = isCurrent;
            branch.stable = isStable;
            [branchList addObject:branch];
        }
        repo.branchList = branchList;
        [repoList addObject:repo];
    }
    NSArray * sortedRepoList = [repoList sortedArrayUsingComparator:^NSComparisonResult(Repository * repo1, Repository * repo2) {
        if(repo1.creatTime > repo2.creatTime) return NSOrderedAscending;
        if(repo1.creatTime < repo2.creatTime) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    return sortedRepoList;
}

- (NSString *)repoConfigPath
{
//    return @"/Users/zhangxiaogang/Project/GitStatus/GitStatus/Test/repo.plist";
    return [[FileUtil documentPath] stringByAppendingPathComponent:kRepoConfigFileName];
}

- (BOOL)isRepoExists: (NSString *)repoName
{
    BOOL result = NO;
    for (NSDictionary * data in self.repoConfigList) {
        NSString * name = data[kRepoNameKey];
        if([name isEqualToString:repoName]){
            result = YES;
            break;
        }
    }
    return result;
}

- (void)addRepoWithName: (NSString *)repoName andPath: (NSString *)repoPath
{
    if(repoName.length == 0) return;
    if(![GitUtil validateRepo:repoPath]) return;
    if([self isRepoExists:repoName]){
        return;
    }
    NSMutableArray * configList = [NSMutableArray array];
    for (NSDictionary * data in self.repoConfigList) {
        [configList addObject:data];
    }
    NSMutableDictionary * config = [NSMutableDictionary dictionary];
    config[kRepoNameKey] = repoName;
    config[kRepoCreateTimeKey] = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    config[kRepoPathKey] = repoPath;
    config[kRepoStableListKey] = @[];
    [configList addObject:config];
    //write
    [configList writeToFile:[self repoConfigPath] atomically:NO];
    [self updateNow];
}

- (void)removeRepoWithName: (NSString *)repoName
{
    if(repoName.length == 0) return;
    if(![self isRepoExists:repoName]){
        return;
    }
    NSMutableArray * configList = [NSMutableArray array];
    for (NSDictionary * data in self.repoConfigList) {
        NSString * name = data[kRepoNameKey];
        if(![name isEqualToString:repoName]){
            [configList addObject:data];
        }
    }
    //write
    [configList writeToFile:[self repoConfigPath] atomically:NO];
    [self updateNow];
}

- (void)addStableBranchWithRepoName: (NSString *)repoName  branchName: (NSString *)branchName
{
    if(repoName.length == 0) return;
    if(![self isRepoExists:repoName]){
        return;
    }
    NSMutableArray * configList = [NSMutableArray array];
    NSDictionary * targetRepo = nil;
    for (NSDictionary * data in self.repoConfigList) {
        NSString * name = data[kRepoNameKey];
        if(![name isEqualToString:repoName]){
            [configList addObject:data];
        }else{
            targetRepo = data;
        }
    }
    if(targetRepo){
        NSMutableDictionary * mutableRepoConfig = [NSMutableDictionary dictionary];
        mutableRepoConfig[kRepoNameKey] = targetRepo[@"name"];
        mutableRepoConfig[kRepoPathKey] = targetRepo[kRepoPathKey];
        NSArray * stableList = targetRepo[kRepoStableListKey];
        NSMutableArray * mutableStableList = [NSMutableArray array];
        for (NSString * stableBranchName in stableList) {
            [mutableStableList addObject:stableBranchName];
        }
        [mutableStableList addObject:branchName];
        mutableRepoConfig[kRepoStableListKey] = mutableStableList;
        [configList addObject:mutableRepoConfig];
    }
    //write
    [configList writeToFile:[self repoConfigPath] atomically:NO];
    [self updateNow];
}

- (void)removeStableBranchWithRepoName: (NSString *)repoName branchName: (NSString *)branchName
{
    if(repoName.length == 0) return;
    if(![self isRepoExists:repoName]){
        return;
    }
    NSMutableArray * configList = [NSMutableArray array];
    NSDictionary * targetRepo = nil;
    for (NSDictionary * data in self.repoConfigList) {
        NSString * name = data[kRepoNameKey];
        if(![name isEqualToString:repoName]){
            [configList addObject:data];
        }else{
            targetRepo = data;
        }
    }
    if(targetRepo){
        NSMutableDictionary * mutableRepoConfig = [NSMutableDictionary dictionary];
        mutableRepoConfig[kRepoNameKey] = targetRepo[kRepoNameKey];
        mutableRepoConfig[kRepoPathKey] = targetRepo[kRepoPathKey];
        NSArray * stableList = targetRepo[kRepoStableListKey];
        NSMutableArray * mutableStableList = [NSMutableArray array];
        for (NSString * stableBranchName in stableList) {
            if(![stableBranchName isEqualToString:branchName]){
                [mutableStableList addObject:branchName];
            }
        }
        mutableRepoConfig[kRepoStableListKey] = mutableStableList;
        [configList addObject:mutableRepoConfig];
    }
    //write
    [configList writeToFile:[self repoConfigPath] atomically:NO];
    [self updateNow];
}

- (void)updateNow
{
    [self loadRepoConfig];
    [self notify];
}

- (void)notify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRepoUtilRepoUpdatedNotification object:self];
}

@end




























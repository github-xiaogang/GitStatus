//
//  RepoUtil.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^RepoLoadCallback)(NSArray * repoList);

extern NSString * const kRepoUtilRepoUpdatedNotification;

@interface RepoUtil : NSObject

+ (RepoUtil *)sharedUtil;
//异步获取
- (void)asyncLoadRepoList: (RepoLoadCallback)callback;

- (void)addRepoWithName: (NSString *)name andPath: (NSString *)repoPath;
- (void)removeRepoWithName: (NSString *)name;
- (void)addStableBranchWithRepoName: (NSString *)repoName branchName: (NSString *)branchName;
- (void)removeStableBranchWithRepoName: (NSString *)repoName branchName: (NSString *)branchName;

//debug 同步获取
- (NSArray *)repoList;

@end

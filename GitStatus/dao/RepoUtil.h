//
//  RepoUtil.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoUtil : NSObject

+ (RepoUtil *)sharedUtil;
- (NSArray *)repoList;

- (void)markConfigDirty;

- (void)addRepoWithName: (NSString *)name andPath: (NSString *)repoPath;
- (void)removeRepoWithName: (NSString *)name;
- (void)addStableBranchWithRepoName: (NSString *)repoName branchName: (NSString *)branchName;
- (void)removeStableBranchWithRepoName: (NSString *)repoName branchName: (NSString *)branchName;



@end

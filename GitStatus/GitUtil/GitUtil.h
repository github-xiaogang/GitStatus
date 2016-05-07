//
//  GitUtil.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitUtil : NSObject


+ (GitUtil *)sharedUtil;

- (BOOL)setCurrentRepo: (NSString *)repoPath;
- (NSString *)currentRepo;

+ (BOOL)validateRepo: (NSString *)repoPath;


- (NSArray *)branchList;
- (NSArray *)branchListAndCurrentBranch: (NSString **)branchPtr;
- (NSString *)currentBranch;
- (BOOL)isRepoClean;

@end

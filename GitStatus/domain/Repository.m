//
//  Repository.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "Repository.h"

@implementation Repository

- (BOOL)isSafe
{
    BOOL result = YES;
    Branch * currentBranch = nil;
    for (Branch * branch in self.branchList) {
        if(branch.isCurrent){
            currentBranch = branch;
            break;
        }
    }
    if(currentBranch.isStable){
        result = NO;
    }
    return result;
}


@end

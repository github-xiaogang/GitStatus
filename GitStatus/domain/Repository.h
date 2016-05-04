//
//  Repository.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * branchList;
@property (nonatomic, assign, getter=isClean) BOOL clean;

- (BOOL)isSafe;

@end

//
//  Branch.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Branch : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign, getter=isStable) BOOL stable;
@property (nonatomic, assign, getter=isCurrent) BOOL current;

@end

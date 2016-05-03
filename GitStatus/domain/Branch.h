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
@property (nonatomic, assign) BOOL stable;
@property (nonatomic, assign) BOOL current;

@end

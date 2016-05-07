//
//  StatusMonitor.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/7.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kStatusMonitorRepoUpdatedNotification;

@interface StatusMonitor : NSObject

+ (StatusMonitor *)sharedMonitor;
- (void)start;

@property (nonatomic, assign, readonly) BOOL isClean;
@property (nonatomic, assign, readonly) BOOL isSafe;

@end
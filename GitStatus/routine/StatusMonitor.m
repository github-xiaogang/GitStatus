//
//  StatusMonitor.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/7.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "StatusMonitor.h"
#import "RepoUtil.h"


static NSString * const kStatusMonitorRepoUpdatedNotification = @"StatusMonitorRepoUpdatedNotification";

static NSTimeInterval const AUTO_UPDATE_INTERVAL = 3.0f;

@interface StatusMonitor ()

@property (nonatomic, assign, readwrite) BOOL isClean;
@property (nonatomic, assign, readwrite) BOOL isSafe;

@property (nonatomic, strong) NSArray * repoList;
@property (nonatomic, assign, getter=isUpdating) BOOL updating;

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation StatusMonitor

+ (StatusMonitor *)sharedMonitor
{
    static StatusMonitor * sharedMonitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMonitor = [[StatusMonitor alloc] init];
    });
    return sharedMonitor;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isClean = YES;
        self.isSafe = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kRepoUtilRepoUpdatedNotification object:[RepoUtil sharedUtil]];
    }
    return self;
}

- (void)start
{
    [self update];
    self.timer = [NSTimer timerWithTimeInterval:AUTO_UPDATE_INTERVAL target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)update
{
    if(self.isUpdating) return;
    RepoUtil * repoUtil = [RepoUtil sharedUtil];
    self.updating = YES;
    [repoUtil asyncLoadRepoList:^(NSArray *repoList) {
        self.updating = NO;
        self.repoList = repoList;
        [self doRepoStatusCheck];
    }];
}

- (void)doRepoStatusCheck
{
    BOOL isClean = YES;
    BOOL isSafe = YES;
    
    for (Repository * repo in self.repoList) {
        if(isClean && ![repo isClean]){
            isClean = NO;
        }
        if(isSafe && ![repo isSafe]){
            isSafe = NO;
        }
        if(!isClean && !isSafe){
            break;
        }
    }
    self.isClean = isClean;
    self.isSafe = isSafe;
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusMonitorRepoUpdatedNotification object:self];
}


@end































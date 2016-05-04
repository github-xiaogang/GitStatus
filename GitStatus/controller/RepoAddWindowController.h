//
//  RepoAddViewController.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RepoAddWindowController : NSWindowController

@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);

@end

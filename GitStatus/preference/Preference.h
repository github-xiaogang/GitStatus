//
//  Preference.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/7.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preference : NSObject

+ (BOOL)isLaunchAtStartup;
+ (void)setLaunchAtStartup: (BOOL)startup;

+ (NSString *)gitClient;
+ (void)setGitClient: (NSString *)gitClient;

@end

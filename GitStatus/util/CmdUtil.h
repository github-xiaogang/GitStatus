//
//  CmdUtil.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmdUtil : NSObject

+ (NSString *)runCmd: (NSString *)cmd workPath: (NSString *)workPath;

@end

//
//  FileUtil.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+ (BOOL)fileExists: (NSString *)path
{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    return [fileManger fileExistsAtPath:path];
}

+ (BOOL)dirExists: (NSString *)dirPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = NO;
    isExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    return (isExists && isDir);
}

+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}


@end

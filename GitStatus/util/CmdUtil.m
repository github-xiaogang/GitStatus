//
//  CmdUtil.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/3.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "CmdUtil.h"

@implementation CmdUtil

+ (NSString *)runCmd: (NSString *)cmd workPath: (NSString *)workPath
{
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    if(workPath){
        task.currentDirectoryPath = workPath;
    }
    [task setArguments:@[@"-c",cmd]];
    [task waitUntilExit];
    
    NSPipe * pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    NSFileHandle * file = [pipe fileHandleForReading];
    [task launch];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    NSString * output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

@end

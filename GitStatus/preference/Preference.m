//
//  Preference.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/7.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

//http://bdunagan.com/2010/09/25/cocoa-tip-enabling-launch-on-startup/

static NSString * const kUserDefaultGitClient = @"gitclient";

#import "Preference.h"

@import CoreServices;
@import CoreFoundation;

@implementation Preference

// MIT license
+ (BOOL)isLaunchAtStartup
{
    // See if the app is currently in LoginItems.
    LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
    // Store away that boolean.
    BOOL isInList = itemRef != nil;
    // Release the reference if it exists.
    if (itemRef != nil) CFRelease(itemRef);
    
    return isInList;
}

+ (void)setLaunchAtStartup: (BOOL)startup
{
    BOOL shouldBeToggled = startup;
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return;
    if (shouldBeToggled) {
        // Add the app to the LoginItems list.
        CFURLRef appUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
        if (itemRef) CFRelease(itemRef);
    }
    else {
        // Remove the app from the LoginItems list.
        LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
        LSSharedFileListItemRemove(loginItemsRef,itemRef);
        if (itemRef != nil) CFRelease(itemRef);
    }
    CFRelease(loginItemsRef);
}

+ (LSSharedFileListItemRef)itemRefInLoginItems {
    LSSharedFileListItemRef itemRef = nil;
    // Get the app's URL.
    NSURL *appUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return nil;
    // Iterate over the LoginItems.
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
    for (int currentIndex = 0; currentIndex < [loginItems count]; currentIndex++) {
        // Get the current LoginItem and resolve its URL.
        LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)[loginItems objectAtIndex:currentIndex];
        CFErrorRef * error = nil;
        CFURLRef itemUrl = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, error);
        // Compare the URLs for the current LoginItem and the app.
        if ([(__bridge NSURL *)itemUrl isEqual:appUrl]) {
            // Save the LoginItem reference.
            itemRef = currentItemRef;
        }
    }
    // Retain the LoginItem reference.
    if (itemRef != nil) CFRetain(itemRef);
    // Release the LoginItems lists.
    CFRelease(loginItemsRef);
    
    return itemRef;
}

+ (NSString *)gitClient
{
    NSString * client = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultGitClient];
    if(client.length == 0){
        client = @"";
    }
    return client;
}


+ (void)setGitClient: (NSString *)gitClient
{
    if(gitClient.length == 0){
        gitClient = @"";
    }
    [[NSUserDefaults standardUserDefaults] setValue:gitClient forKey:kUserDefaultGitClient];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end





















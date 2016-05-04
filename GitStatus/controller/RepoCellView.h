//
//  RepoCell.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol RepoCellViewDelegate;
@interface RepoCellView : NSView

@property (nonatomic, weak) id<RepoCellViewDelegate> delegate;

- (void)setData: (id)data;
+ (CGFloat)preferedHeight;
+ (RepoCellView *)newInstance;

@end

@protocol RepoCellViewDelegate <NSObject>

- (void)repoCellViewSelected: (RepoCellView *)repoCellView;

@end

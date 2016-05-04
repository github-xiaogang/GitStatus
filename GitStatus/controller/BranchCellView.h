//
//  BranchCellView.h
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BranchCellViewDelegate;
@interface BranchCellView : NSView

@property (nonatomic, weak) id<BranchCellViewDelegate> delegate;

- (void)setData: (id)data;
+ (CGFloat)preferedHeight;
+ (BranchCellView *)newInstance;

@end

@protocol BranchCellViewDelegate <NSObject>

- (void)branchCellView: (BranchCellView *)branchCellView branchChecked: (BOOL)checked;

@end

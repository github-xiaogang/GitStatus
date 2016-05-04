//
//  BranchCellView.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "BranchCellView.h"

@interface BranchCellView ()
@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSButton *stableCheckButton;

@property (weak) IBOutlet NSView *lineView;


@end

@implementation BranchCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.wantsLayer = YES;
    self.lineView.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
}

- (void)setData: (id)data
{
    Branch * branch = (Branch *)data;
    NSString * name = branch.name;
    BOOL isCurrent = branch.isCurrent;
    self.nameTextfield.stringValue = [NSString stringWithFormat:@"%@%@", isCurrent ? @"* ":@"  ",name];
    BOOL isStable = [branch isStable];
    self.stableCheckButton.state = isStable ? 1:0;
}

+ (CGFloat)preferedHeight
{
    return 41.0f;
}

+ (BranchCellView *)newInstance
{
    NSArray * topObjects = nil;
    if(![[NSBundle bundleForClass:[self class]] loadNibNamed:@"BranchCellView" owner:nil topLevelObjects:&topObjects]){
        NSLog(@"load cell error");
    }
    BranchCellView * cell = nil;
    for (id object in topObjects) {
        if([object isKindOfClass:[BranchCellView class]]){
            cell = object;
            break;
        }
    }
    return cell;
}

- (IBAction)stableCheckButtonPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(branchCellView:branchChecked:)]){
        [self.delegate branchCellView:self branchChecked:self.stableCheckButton.state];
    }
}


@end










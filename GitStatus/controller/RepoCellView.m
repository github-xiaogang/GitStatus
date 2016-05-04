//
//  RepoCell.m
//  GitStatus
//
//  Created by 张小刚 on 16/5/4.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "RepoCellView.h"

@interface RepoCellView ()

@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSView *cleanStatusView;
@property (weak) IBOutlet NSView *safeStatusView;

@property (weak) IBOutlet NSTextField *countTextfield;
@property (weak) IBOutlet NSView *lineView;


@end

@implementation RepoCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.wantsLayer = YES;
    self.lineView.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
}

- (void)setData: (id)data
{
    Repository * repo = (Repository *)data;
    self.nameTextfield.stringValue = repo.name;
    self.countTextfield.stringValue = [NSString stringWithFormat:@"%ld branches",repo.branchList.count];
    BOOL isClean = [repo isClean];
    BOOL isSafe = [repo isSafe];
    if(isClean){
        self.cleanStatusView.layer.backgroundColor = [Appearance niceColor].CGColor;
    }else{
        self.cleanStatusView.layer.backgroundColor = [Appearance sadColor].CGColor;
    }
    if(isSafe){
        self.safeStatusView.layer.backgroundColor = [Appearance niceColor].CGColor;
    }else{
        self.safeStatusView.layer.backgroundColor = [Appearance sadColor].CGColor;
    }
}

+ (CGFloat)preferedHeight
{
    return 65.0f;
}

+ (RepoCellView *)newInstance
{
    NSArray * topObjects = nil;
    if(![[NSBundle bundleForClass:[self class]] loadNibNamed:@"RepoCellView" owner:nil topLevelObjects:&topObjects]){
        NSLog(@"load cell error");
    }
    RepoCellView * cell = nil;
    for (id object in topObjects) {
        if([object isKindOfClass:[RepoCellView class]]){
            cell = object;
            break;
        }
    }
    return cell;
}

- (IBAction)contentButtonPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(repoCellViewSelected:)]){
        [self.delegate repoCellViewSelected:self];
    }
}


@end












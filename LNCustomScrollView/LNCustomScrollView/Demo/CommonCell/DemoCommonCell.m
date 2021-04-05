//
//  DemoCommonCell.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "DemoCommonCell.h"

NSString * const kDemoCommonCell = @"kDemoCommonCell";

@interface DemoCommonCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DemoCommonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self addConstraints];
        self.contentView.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:(rand()%255)/255.f];
    }
    return self;
}

- (void)addSubviews
{
    [self.contentView addSubview:self.titleLabel];
}

- (void)addConstraints
{
    self.titleLabel.frame = self.contentView.frame;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end



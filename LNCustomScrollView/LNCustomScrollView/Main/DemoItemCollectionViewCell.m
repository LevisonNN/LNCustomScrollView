//
//  DemoItemCollectionViewCell.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "DemoItemCollectionViewCell.h"

NSString *const kDemoItemCollectionViewCell = @"kDemoItemCollectionViewCell";

@interface DemoItemCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) DemoItemObj *itemObj;

@end

@implementation DemoItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)setItemObj:(DemoItemObj *)item
{
    _itemObj = item;
    self.titleLabel.text = item.title;
    self.contentView.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:(rand()%255)/255.f];
}

- (void)addSubviews
{
    [self.contentView addSubview:self.titleLabel];
}

- (void)addConstraints
{
    self.titleLabel .frame = self.contentView.frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraints];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end




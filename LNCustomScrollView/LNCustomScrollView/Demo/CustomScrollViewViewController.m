//
//  CustomScrollViewViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "CustomScrollViewViewController.h"
#import "LNCustomScrollView.h"

@interface CustomScrollViewViewController ()

@property (nonatomic, strong) LNCustomScrollView *customScrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
    
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)addSubviews
{
    [self.view addSubview:self.customScrollView];
    [self.customScrollView addSubview:self.imageView];
}

- (void)addConstraints
{
    self.customScrollView.frame = self.view.bounds;
    
    UIImage *image = [UIImage imageNamed:@"fulian"];
    CGFloat imageHeight = self.view.bounds.size.height;
    CGFloat imageWidth = imageHeight * (image.size.width/image.size.height);
    self.imageView.frame = CGRectMake(0.f, 0.f, imageWidth, imageHeight);
    self.imageView.image = image;
    self.customScrollView.contentSize = CGSizeMake(imageWidth, imageHeight);
    
    self.customScrollView.bounces = YES;
}

- (LNCustomScrollView *)customScrollView
{
    if (!_customScrollView) {
        _customScrollView = [[LNCustomScrollView alloc] init];
    }
    return _customScrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end


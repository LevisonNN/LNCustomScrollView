//
//  BouncesObservationViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "BouncesObservationViewController.h"
#import "LNCustomScrollViewClock.h"
#import "DemoCommonCell.h"

@interface BouncesObservationViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
LNCustomScrollViewClockProtocol
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL isNeedRecord;

@end

@implementation BouncesObservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[LNCustomScrollViewClock shareInstance] addObject:self];
}

- (void)customScrollViewClockUpdateTimeInterval:(NSTimeInterval)time
{
    if (self.collectionView.contentOffset.y < -64.f && (!self.collectionView.isTracking) && self.isNeedRecord) {
        NSLog(@"偏移 %lf", self.collectionView.contentOffset.y);
    }
}

- (void)addSubviews
{
    [self.view addSubview:self.collectionView];
}

- (void)addConstraints
{
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1000;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCommonCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kDemoCommonCell forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88.f, 88.f);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:DemoCommonCell.class forCellWithReuseIdentifier:kDemoCommonCell];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

//测量方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //可以从这里测量出距离和速度的关系
    self.isNeedRecord = YES;
    
    NSLog(@"startY:%@", @(scrollView.contentOffset.y));
    NSLog(@"startVelocity:%@", @(velocity.y));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isNeedRecord = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end


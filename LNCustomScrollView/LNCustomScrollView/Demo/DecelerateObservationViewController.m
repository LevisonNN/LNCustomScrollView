//
//  DecelerateObservationViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "DecelerateObservationViewController.h"
#import "DemoCommonCell.h"

@interface DecelerateObservationViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation DecelerateObservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
    self.view.backgroundColor = [UIColor whiteColor];
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
    DemoCommonCell *decelerateCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kDemoCommonCell forIndexPath:indexPath];
    return decelerateCell;
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"DecelerateVelocity:%lf", velocity.y);
    NSLog(@"DecelerateDistance:%lf", targetContentOffset->y - scrollView.contentOffset.y);
}

@end

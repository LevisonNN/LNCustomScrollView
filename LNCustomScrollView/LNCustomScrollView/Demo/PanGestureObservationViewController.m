//
//  PanGestureObservationViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "PanGestureObservationViewController.h"
#import "DemoCommonCell.h"


@interface PanGestureObservationViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) CGFloat lastPanDisplace;

@property (nonatomic, assign) CGFloat lastContentOffsetDisplace;

@property (nonatomic, assign) NSInteger mod;
@property (nonatomic, assign) NSInteger count;

@end

@implementation PanGestureObservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mod = 5;
    self.count = 1;
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isTracking) {
        if (self.lastPanDisplace < -10000.f) {
            self.lastPanDisplace = [scrollView.panGestureRecognizer locationInView:scrollView].y;
        }
        
        if (self.lastContentOffsetDisplace < -10000.f) {
            self.lastContentOffsetDisplace = scrollView.contentOffset.y;
        }
        
        CGFloat deltaPanDisplace = [scrollView.panGestureRecognizer locationInView:scrollView].y - self.lastPanDisplace;
        
        CGFloat deltaContentOffsetDisplace = scrollView.contentOffset.y - self.lastContentOffsetDisplace;
        
        
        self.count++;
        if (self.count % self.mod == 0) {
            self.lastPanDisplace = [scrollView.panGestureRecognizer locationInView:scrollView].y;
            self.lastContentOffsetDisplace = scrollView.contentOffset.y;
            
            CGFloat convertScale = fabs(deltaContentOffsetDisplace/deltaPanDisplace);
            NSLog(@"convertScale:%lf contentOffset:%lf", convertScale, fabs(self.collectionView.contentOffset.y + 88.f));
        }
        
    } else {
        self.lastPanDisplace = -10001.f;
        self.lastContentOffsetDisplace = -10001.f;
        self.count = 0;
    }
}

@end

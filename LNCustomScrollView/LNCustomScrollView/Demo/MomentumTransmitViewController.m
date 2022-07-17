//
//  MomentumTransmitViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 17.7.22.
//  Copyright © 2022 Levison. All rights reserved.
//

#import "MomentumTransmitViewController.h"
#import "LNRestMomentumDetector.h"
#import "LNMomentumImpulser.h"

@interface MomentumTransmitViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LNRestMomentumSerializer, LNMomentumImpulserSerializer>

@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout1;
@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout2;

//这对是把collectionView1的向右冲量传给collectionView2转为下冲量
@property (nonatomic, strong) LNRestMomentumDetector *detector12;
@property (nonatomic, strong) LNMomentumImpulser *impulser12;

//这对是把collectionView2的向上冲量传给collectionView1转为左冲量
@property (nonatomic, strong) LNRestMomentumDetector *detector21;
@property (nonatomic, strong) LNMomentumImpulser *impulser21;

//通常只需要单方向

@end

@implementation MomentumTransmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
    // Do any additional setup after loading the view.
}

- (void)addSubviews
{
    [self.view addSubview:self.collectionView1];
    [self.view addSubview:self.collectionView2];
}

- (void)addConstraints
{
    self.collectionView1.frame = CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height/2.f);
    self.collectionView2.frame = CGRectMake(0.f, self.view.bounds.size.height/2.f, self.view.bounds.size.width, self.view.bounds.size.height/2.f);
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100.f, 100.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(random()%255)/255.f green:(random()%255)/255.f blue:(random()%255)/255.f alpha:1.f];
    return cell;
}

- (UICollectionView *)collectionView1
{
    if (!_collectionView1) {
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout1];
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        //因为只有减速没有弹性，所以这里是局限
        _collectionView1.bounces = NO;
        [_collectionView1 registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"kCollectionViewCell"];
    }
    return _collectionView1;
}

- (UICollectionView *)collectionView2
{
    if (!_collectionView2) {
        _collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout2];
        _collectionView2.dataSource = self;
        _collectionView2.delegate = self;
        //因为只有减速没有弹性，所以这里是局限
        _collectionView2.bounces = NO;
        [_collectionView2 registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"kCollectionViewCell"];
    }
    return _collectionView2;
}

- (UICollectionViewFlowLayout *)flowLayout1
{
    if (!_flowLayout1) {
        _flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout1;
}

- (UICollectionViewFlowLayout *)flowLayout2
{
    if (!_flowLayout2) {
        _flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout2;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.collectionView1) {
        [self.detector12 scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
    if (scrollView == self.collectionView2) {
        [self.detector21 scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.collectionView2) {
        if (!decelerate) {
            [self.impulser12 removeCurrentMomentum];
        }
    }
    
    if (scrollView == self.collectionView1) {
        if (!decelerate) {
            [self.impulser21 removeCurrentMomentum];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView1) {
        [self.detector12 scrollViewDidEndDecelerating:scrollView];
        [self.impulser21 removeCurrentMomentum];
    }
    
    if (scrollView == self.collectionView2) {
        [self.detector21 scrollViewDidEndDecelerating:scrollView];
        [self.impulser12 removeCurrentMomentum];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView2) {
        [self.impulser12 removeCurrentMomentum];
    }
    
    if (scrollView == self.collectionView1) {
        [self.impulser21 removeCurrentMomentum];
    }
}

- (LNRestMomentumDetector *)detector12
{
    if (!_detector12) {
        _detector12 = [[LNRestMomentumDetector alloc] init];
        _detector12.delegate = self.impulser12;
        _detector12.serializer = self;
        _detector12.effectDirection = LNMomentumEffectDirectionHorizontal;
    }
    return _detector12;
}

// LNRestMomentumSerializer , 判断某个剩余速度是否应该生效
- (BOOL)detector:(LNRestMomentumDetector *)detector shouldStashMomentum:(LNMomentumObj *)momentum
{
    if (detector == self.detector12) {
        //只有撞到右侧边界才生效
        switch (momentum.direction) {
            case LNMomentumDirectionRight: {
                return YES;
            } break;
            default: return NO;
                break;
        }
        return NO;
    } else if (detector == self.detector21){
        //只有撞到顶部才生效
        switch (momentum.direction) {
            case LNMomentumDirectionTop: {
                return YES;
            } break;
            default: return NO;
                break;
        }
        return NO;
    }
    return NO;
}

- (LNMomentumImpulser *)impulser12
{
    if (!_impulser12) {
        _impulser12 = [[LNMomentumImpulser alloc] initWithTargetScrollView:self.collectionView2];
        _impulser12.serializer = self;
    }
    return _impulser12;
}

- (BOOL)impulser:(LNMomentumImpulser *)impulser shouldReactToMomentum:(LNMomentumObj *)momentum
{
    return YES;
}

- (LNMomentumObj *)impulser:(LNMomentumImpulser *)impulser momentumForOriginalMomentum:(LNMomentumObj *)obj
{
    //传过来是向右，过滤成向下
    if (impulser == self.impulser12) {
        obj.direction = LNMomentumDirectionBottom;
        return obj;
    } else if (impulser == self.impulser21) {
        obj.direction = LNMomentumDirectionLeft;
        return obj;
    }
    return obj;
}

- (LNMomentumImpulser *)impulser21
{
    if (!_impulser21) {
        _impulser21 = [[LNMomentumImpulser alloc] initWithTargetScrollView:self.collectionView1];
        _impulser21.serializer = self;
        //这样修改质量之后detector21 会很难撞动impulser21，impulser21只能获取到detector21yuliang速度的十分之一
        //m1*v1 = m2*v2
        //_impulser21.mass = 10.f;
    }
    return _impulser21;
}

- (LNRestMomentumDetector *)detector21
{
    if (!_detector21) {
        _detector21 = [[LNRestMomentumDetector alloc] init];
        _detector21.delegate = self.impulser21;
        _detector21.serializer = self;
        _detector21.effectDirection = LNMomentumEffectDirectionVertical;
        //_detector21.mass = 1;
    }
    return _detector21;
}

@end

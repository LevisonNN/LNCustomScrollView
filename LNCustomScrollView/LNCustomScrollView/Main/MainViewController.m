//
//  MainViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "MainViewController.h"
#import "DemoItemObj.h"
#import "DemoItemCollectionViewCell.h"
#import "DecelerateObservationViewController.h"
#import "BouncesObservationViewController.h"
#import "BouncesOptimizationViewController.h"
#import "PanGestureObservationViewController.h"
#import "CustomScrollViewViewController.h"

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) NSArray <DemoItemObj *> *demoItemArr;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
    [self loadObjs];
}

- (void)addSubviews
{
    [self.view addSubview:self.collectionView];
}

- (void)addConstraints
{
    self.collectionView.frame = self.view.bounds;
}

- (void)loadObjs
{
    NSMutableArray *demoItemMArr = [[NSMutableArray alloc] init];
    
    DemoItemObj *decelerateMeasureObj = [[DemoItemObj alloc] init];
    decelerateMeasureObj.type = DemoTypeDecelerateObservation;
    decelerateMeasureObj.title = @"Decelerate";
    [demoItemMArr addObject:decelerateMeasureObj];
    
    DemoItemObj *bouncesMeasureObj = [[DemoItemObj alloc] init];
    bouncesMeasureObj.type = DemoTypeBouncesObservation;
    bouncesMeasureObj.title = @"Bounces";
    [demoItemMArr addObject:bouncesMeasureObj];
    
    DemoItemObj *optimizationObj = [[DemoItemObj alloc] init];
    optimizationObj.type = DemoTypeOptimization;
    optimizationObj.title = @"Optimization";
    [demoItemMArr addObject:optimizationObj];
    
    DemoItemObj *panGestureMeasureObj = [[DemoItemObj alloc] init];
    panGestureMeasureObj.type = DemoTypePanGestureObservation;
    panGestureMeasureObj.title = @"PanGesture";
    [demoItemMArr addObject:panGestureMeasureObj];
    
    DemoItemObj *customScrollViewObj = [[DemoItemObj alloc] init];
    customScrollViewObj.type = DemoTypeCustomScrollView;
    customScrollViewObj.title = @"CustomScrollView";
    [demoItemMArr addObject:customScrollViewObj];
    
    self.demoItemArr = demoItemMArr.copy;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:DemoItemCollectionViewCell.class forCellWithReuseIdentifier:kDemoItemCollectionViewCell];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    }
    return _flowLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demoItemArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2.f - 42.f, 44.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoItemCollectionViewCell *cell = (DemoItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDemoItemCollectionViewCell forIndexPath:indexPath];
    [cell setItemObj:self.demoItemArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    switch (self.demoItemArr[indexPath.row].type) {
        case DemoTypeDecelerateObservation: {
            DecelerateObservationViewController *vc = [[DecelerateObservationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case DemoTypeBouncesObservation: {
            BouncesObservationViewController *vc = [[BouncesObservationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case DemoTypeOptimization: {
            BouncesOptimizationViewController *vc = [[BouncesOptimizationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case DemoTypePanGestureObservation: {
            PanGestureObservationViewController *vc = [[PanGestureObservationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case DemoTypeCustomScrollView: {
            CustomScrollViewViewController *vc = [[CustomScrollViewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default: {
            
        } break;
    }
}

@end



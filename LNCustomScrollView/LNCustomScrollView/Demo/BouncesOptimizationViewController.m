//
//  BouncesOptimizationViewController.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "BouncesOptimizationViewController.h"
#import "BouncesOptimizationTrainer.h"
#import "BouncesOptimizationDataList.h"
#import "DemoCommonCell.h"


#define BorderLineStartPointX 20.f
#define BorderLineStartPointY 300.f

#define xBorderLineLength 300.f
#define yBorderLineLength 200.f

@interface BouncesOptimizationViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
LNBouncesOptimizationTrainerDelegate
>

@property (nonatomic, strong) BouncesOptimizationDataList *dataList;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UILabel *selectionLabel;

@property (nonatomic, strong) UIView *backgroundContainerView;
@property (nonatomic, strong) UIView *yBorderLine;
@property (nonatomic, strong) UIView *xBorderLine;

@property (nonatomic, strong) UIView *originalDataPointContainerView;
@property (nonatomic, strong) UIView *optimizationDataPointContainerView;

@property (nonatomic, strong) UILabel *biasLabel;
@property (nonatomic, strong) UILabel *deltaLabel;
@property (nonatomic, strong) UILabel *aLabel;
@property (nonatomic, strong) UILabel *phiLabel;

@property (nonatomic, weak) NSArray <NSNumber *> *currentOriginalDataArray;
@property (nonatomic, copy) NSArray <NSNumber *> *currentOptimizationArray;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) LNBouncesOptimizationTrainer *trainer;

@end

@implementation BouncesOptimizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
    [self addConstraints];
}

- (void)addSubviews
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectionLabel];
    
    [self.view addSubview:self.backgroundContainerView];
    [self.backgroundContainerView addSubview:self.xBorderLine];
    [self.backgroundContainerView addSubview:self.yBorderLine];
    [self.backgroundContainerView addSubview:self.biasLabel];
    [self.backgroundContainerView addSubview:self.aLabel];
    [self.backgroundContainerView addSubview:self.deltaLabel];
    [self.backgroundContainerView addSubview:self.phiLabel];
    
    [self.view addSubview:self.originalDataPointContainerView];
    [self.view addSubview:self.optimizationDataPointContainerView];
    
    
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
}

- (void)addConstraints
{
    self.collectionView.frame = CGRectMake(0.f, 88.f, self.view.frame.size.width - 132.f, 44.f);
    self.selectionLabel.frame = CGRectMake(self.view.frame.size.width - 120.f, 88.f, 108.f, 44.f);
    
    self.backgroundContainerView.frame = CGRectMake(0.f, 132.f, self.view.frame.size.width, self.view.frame.size.height- 132.f - 88.f);
    self.xBorderLine.frame = CGRectMake(BorderLineStartPointX, BorderLineStartPointY, xBorderLineLength, 1.f/[UIScreen mainScreen].scale);
    self.yBorderLine.frame = CGRectMake(BorderLineStartPointX, BorderLineStartPointY - yBorderLineLength, 1.f/[UIScreen mainScreen].scale, yBorderLineLength);
    
    self.biasLabel.frame = CGRectMake(20.f, 10.f, 200.f, 20.f);
    self.aLabel.frame = CGRectMake(20.f, 30.f, 200.f, 20.f);
    self.deltaLabel.frame = CGRectMake(20.f, 50.f, 200.f, 20.f);
    self.phiLabel.frame = CGRectMake(20.f, 70.f, 200.f, 20.f);
    
    self.originalDataPointContainerView.frame = self.backgroundContainerView.frame;
    self.optimizationDataPointContainerView.frame = self.backgroundContainerView.frame;
    
    self.startButton.frame = CGRectMake(0.f, self.view.frame.size.height - 132.f, self.view.frame.size.width/2.f, 88.f);
    self.stopButton.frame = CGRectMake(self.view.frame.size.width/2.f, self.view.frame.size.height - 132.f, self.view.frame.size.width/2.f, 88.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.dataMArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88.f, 44.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCommonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDemoCommonCell forIndexPath:indexPath];
    cell.titleLabel.text = [self.dataList.dataMArray objectAtIndex:indexPath.item].title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentOriginalDataArray = [self.dataList.dataMArray objectAtIndex:indexPath.row].dataArray;
    [self redrawOriginalData];
    self.selectionLabel.text = [self.dataList.dataMArray objectAtIndex:indexPath.row].title;
}

- (void)redrawOriginalData
{
    [self redraw:self.currentOriginalDataArray inContainerView:self.originalDataPointContainerView color:[UIColor blackColor]];
}

- (void)redrawOptimizationData
{
    [self redraw:self.currentOptimizationArray inContainerView:self.optimizationDataPointContainerView color:[UIColor redColor]];
}

- (void)redraw:(NSArray <NSNumber *> *)numberArray inContainerView:(UIView *)containerView color:(UIColor *)color
{
    for (UIView *subview in containerView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < numberArray.count ; i++) {
        UIView *pointView = [[UIView alloc] init];
        pointView.backgroundColor = color;
        [containerView addSubview:pointView];
        
        pointView.frame = CGRectMake(BorderLineStartPointX + i * 5.f, BorderLineStartPointY - [numberArray[i] floatValue] , 2.f, 2.f);
    }
}

- (UILabel *)selectionLabel
{
    if (!_selectionLabel) {
        _selectionLabel = [[UILabel alloc] init];
        _selectionLabel.textColor = [UIColor blackColor];
    }
    return _selectionLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [_collectionView registerClass:DemoCommonCell.class forCellWithReuseIdentifier:kDemoCommonCell];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsSelection = YES;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0.f, 24.f, 0.f, 24.f);
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UIView *)backgroundContainerView
{
    if (!_backgroundContainerView) {
        _backgroundContainerView = [[UIView alloc] init];
    }
    return _backgroundContainerView;
}

- (UIView *)xBorderLine
{
    if (!_xBorderLine) {
        _xBorderLine = [[UIView alloc] init];
        _xBorderLine.backgroundColor = [UIColor blueColor];
    }
    return _xBorderLine;
}

- (UIView *)yBorderLine
{
    if (!_yBorderLine) {
        _yBorderLine = [[UIView alloc] init];
        _yBorderLine.backgroundColor = [UIColor redColor];
    }
    return _yBorderLine;
}

- (UIView *)originalDataPointContainerView
{
    if (!_originalDataPointContainerView) {
        _originalDataPointContainerView = [[UIView alloc] init];
    }
    return _originalDataPointContainerView;
}

- (UIView *)optimizationDataPointContainerView
{
    if (!_optimizationDataPointContainerView) {
        _optimizationDataPointContainerView = [[UIView alloc] init];
    }
    return _optimizationDataPointContainerView;
}

- (BouncesOptimizationDataList *)dataList
{
    if (!_dataList) {
        _dataList = [[BouncesOptimizationDataList alloc] init];
    }
    return _dataList;
}

- (UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [[UIButton alloc] init];
        _startButton.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:(rand()%255)/255.f];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (void)startButtonClicked
{
    [self.trainer setObservationData:self.currentOriginalDataArray];
    [self.trainer startTraining];
}

- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] init];
        [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _stopButton.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:(rand()%255)/255.f];
        [_stopButton addTarget:self action:@selector(stopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (void)stopButtonClicked
{
    [self.trainer stopTraining];
}

- (LNBouncesOptimizationTrainer *)trainer
{
    if (!_trainer) {
        _trainer = [[LNBouncesOptimizationTrainer alloc] init];
        _trainer.delegate = self;
    }
    return _trainer;
}

- (void)trainerDidUpdate:(LNBouncesOptimizationTrainerResult *)tempResult
{
    NSLog(@"%f", tempResult.currentBias);
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:self.currentOriginalDataArray.count];
    for (NSInteger i = 0 ; i < self.currentOriginalDataArray.count; i++) {
        float t = (i * 0.0167f + tempResult.phi);
        float resultValue = tempResult.a * t * expf(- tempResult.delta * t);
        [mArr addObject:@(resultValue)];
    }
    self.currentOptimizationArray = mArr.copy;
    [self redrawOptimizationData];
    
    self.aLabel.text = [NSString stringWithFormat:@"a:%@",@(tempResult.a)];
    self.deltaLabel.text = [NSString stringWithFormat:@"delta:%@",@(tempResult.delta)];
    self.phiLabel.text = [NSString stringWithFormat:@"phi:%@", @(tempResult.phi)];
    self.biasLabel.text = [NSString stringWithFormat:@"bias:%@", @(tempResult.currentBias)];
}

- (void)trainerDidFinish:(LNBouncesOptimizationTrainerResult *)finalResult
{
    self.aLabel.text = [NSString stringWithFormat:@"a:%@",@(finalResult.a)];
    self.deltaLabel.text = [NSString stringWithFormat:@"delta:%@",@(finalResult.delta)];
    self.phiLabel.text = [NSString stringWithFormat:@"phi:%@", @(finalResult.phi)];
    self.biasLabel.text = [NSString stringWithFormat:@"bias:%@", @(finalResult.currentBias)];
}

- (void)trainerDidInterrupted
{
    [self clear];
}

- (void)clear
{
    for (UIView *subview in self.originalDataPointContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (UIView *subview in self.optimizationDataPointContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.biasLabel.text = @"";
    self.aLabel.text = @"";
    self.deltaLabel.text = @"";
    self.phiLabel.text = @"";
}

- (UILabel *)biasLabel
{
    if (!_biasLabel) {
        _biasLabel = [[UILabel alloc] init];
        _biasLabel.textColor = [UIColor blackColor];
    }
    return _biasLabel;
}

- (UILabel *)aLabel
{
    if (!_aLabel) {
        _aLabel = [[UILabel alloc] init];
        _aLabel.textColor = [UIColor blackColor];
    }
    return _aLabel;
}

- (UILabel *)deltaLabel
{
    if (!_deltaLabel) {
        _deltaLabel = [[UILabel alloc] init];
        _deltaLabel.textColor = [UIColor blackColor];
    }
    return _deltaLabel;
}

- (UILabel *)phiLabel
{
    if (!_phiLabel) {
        _phiLabel = [[UILabel alloc] init];
        _phiLabel.textColor = [UIColor blackColor];
    }
    return _phiLabel;
}

@end


//
//  BouncesOptimizationDataList.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "BouncesOptimizationDataList.h"

@interface BouncesOptimizationData ()

@end

@implementation BouncesOptimizationData

@end


@interface BouncesOptimizationDataList ()

@end

@implementation BouncesOptimizationDataList

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadAllLists];
    }
    return self;
}

- (void)loadAllLists
{
    [self loadList1];
    [self loadList2];
    [self loadList3];
}

- (void)loadList1
{
    BouncesOptimizationData *data = [[BouncesOptimizationData alloc] init];
    
    data.title = @"数据1";
    data.dataArray = @[
        @(123.6666),
        @(172.0000),
        @(203.3333),
        @(221.6666),
        @(230.6666),
        @(233.0000),
        @(230.3333),
        @(224.6666),
        @(217.0000),
        @(208.0000),
        @(198.6666),
        @(189.0000),
        @(179.3333),
        @(170.3333),
        @(161.6666),
        @(153.6666),
        @(146.0000),
        @(139.3333),
        @(133.3333),
        @(128.0000),
        @(123.0000),
        @(118.6666),
        @(114.6666),
        @(111.3333),
        @(108.3333),
        @(105.6666),
        @(103.3333),
        @(101.3333),
        @(99.33333),
        @(98.00000),
        @(96.66666),
        @(95.33333),
        @(94.33333),
        @(93.33333),
        @(92.66666),
        @(92.00000),
        @(91.33333),
        @(91.00000),
        @(90.66666),
        @(90.33333),
        @(90.00000),
        @(89.66666),
        @(89.33333),
        @(89.33333),
        @(89.00000),
        @(89.00000),
        @(88.66666),
        @(88.66666),
        @(88.66666)
    ];
    
    data.dataArray = [self cutBaseLine:88.f forArr:data.dataArray];
    
    [self.dataMArray addObject:data];
}

- (void)loadList2
{
    BouncesOptimizationData *data = [[BouncesOptimizationData alloc] init];
    
    data.title = @"数据2";
    data.dataArray = @[
        @(73.500000),
        @(101.500000),
        @(120.000000),
        @(131.500000),
        @(137.000000),
        @(139.000000),
        @(138.500000),
        @(136.000000),
        @(132.500000),
        @(128.000000),
        @(123.000000),
        @(118.000000),
        @(113.000000),
        @(108.000000),
        @(103.500000),
        @(99.000000),
        @(95.500000),
        @(91.500000),
        @(88.500000),
        @(85.500000),
        @(83.000000),
        @(80.500000),
        @(78.500000),
        @(76.500000),
        @(75.000000),
        @(73.500000),
        @(72.000000),
        @(71.000000),
        @(70.000000),
        @(69.500000),
        @(68.500000),
        @(68.000000),
        @(67.500000),
        @(67.000000),
        @(66.500000),
        @(66.000000),
        @(66.000000),
        @(65.500000),
        @(65.500000),
        @(65.000000),
        @(65.000000),
        @(65.000000),
        @(64.500000),
        @(64.500000),
        @(64.500000)
    ];
    
    data.dataArray = [self cutBaseLine:64.f forArr:data.dataArray];
    
    [self.dataMArray addObject:data];
}

- (void)loadList3
{
    BouncesOptimizationData *data = [[BouncesOptimizationData alloc] init];
    
    data.title = @"数据3";
    data.dataArray = @[
        @(457.50000),
        @(448.50000),
        @(431.50000),
        @(409.50000),
        @(384.50000),
        @(358.50000),
        @(332.00000),
        @(306.50000),
        @(282.00000),
        @(259.00000),
        @(237.50000),
        @(218.00000),
        @(200.00000),
        @(183.50000),
        @(169.00000),
        @(156.00000),
        @(144.50000),
        @(134.50000),
        @(125.00000),
        @(117.00000),
        @(110.00000),
        @(104.00000),
        @(98.500000),
        @(94.000000),
        @(90.000000),
        @(86.500000),
        @(83.500000),
        @(80.500000),
        @(78.500000),
        @(76.500000),
        @(74.500000),
        @(73.000000),
        @(72.000000),
        @(70.500000),
        @(69.500000),
        @(69.000000),
        @(68.000000),
        @(67.500000),
        @(67.000000),
        @(66.500000),
        @(66.000000),
        @(66.000000),
        @(65.500000),
        @(65.500000),
        @(65.000000),
        @(65.000000),
        @(65.000000),
        @(64.500000),
        @(64.500000),
        @(64.500000)
    ];
    
    data.dataArray = [self cutBaseLine:64.f forArr:data.dataArray];
    
    [self.dataMArray addObject:data];
}

- (NSArray <NSNumber *> *)cutBaseLine:(float)baseLine forArr:(NSArray <NSNumber *> *)arr
{
    NSMutableArray *resultMArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSNumber *num in arr) {
        float cutNum = [num floatValue] - baseLine;
        [resultMArr addObject:@(cutNum)];
    }
    return resultMArr.copy;
}

- (NSMutableArray<BouncesOptimizationData *> *)dataMArray
{
    if (!_dataMArray) {
        _dataMArray = [[NSMutableArray alloc] init];
    }
    return _dataMArray;
}

@end


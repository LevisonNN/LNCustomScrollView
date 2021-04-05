//
//  BouncesOptimizationDataList.h
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BouncesOptimizationData : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray <NSNumber *> *dataArray;

@end

@interface BouncesOptimizationDataList : NSObject

@property (nonatomic, strong) NSMutableArray <BouncesOptimizationData *> *dataMArray;

@end

NS_ASSUME_NONNULL_END

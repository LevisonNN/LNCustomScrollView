//
//  BouncesOptimizationTrainer.h
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LNBouncesOptimizationTrainerStatus)
{
    LNBouncesOptimizationTrainerStatusFree,
    LNBouncesOptimizationTrainerStatusTraining
};

@interface LNBouncesOptimizationTrainerResult : NSObject

@property (nonatomic, assign) float phi;

@property (nonatomic, assign) float delta;

@property (nonatomic, assign) float a;

@property (nonatomic, assign) float currentBias;

@end

@protocol LNBouncesOptimizationTrainerDelegate <NSObject>
@optional
- (void)trainerDidUpdate:(LNBouncesOptimizationTrainerResult *)tempResult;
- (void)trainerDidFinish:(LNBouncesOptimizationTrainerResult *)finalResult;

- (void)trainerDidInterrupted;

@end

@interface LNBouncesOptimizationTrainer : NSObject

@property (atomic, assign, readonly) LNBouncesOptimizationTrainerStatus status;

@property (nonatomic, weak) NSObject<LNBouncesOptimizationTrainerDelegate> *delegate;

- (void)setObservationData:(NSArray <NSNumber *> *)observationArr;

- (void)startTraining;
- (void)stopTraining;

@end


NS_ASSUME_NONNULL_END

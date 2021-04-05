//
//  BouncesOptimizationTrainer.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "BouncesOptimizationTrainer.h"

@interface LNBouncesOptimizationTrainerResult ()

@end

@implementation LNBouncesOptimizationTrainerResult

@end

@interface LNBouncesOptimizationTrainer ()

@property (atomic, assign) LNBouncesOptimizationTrainerStatus status;

@property (atomic, assign) BOOL shouldStop;

@property (nonatomic, copy) NSArray <NSNumber *> *originalArray;

@end

@implementation LNBouncesOptimizationTrainer
{
    dispatch_queue_t _coculateQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coculateQueue = dispatch_queue_create(0, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setObservationData:(NSArray<NSNumber *> *)observationArr
{
    if (self.status == LNBouncesOptimizationTrainerStatusFree) {
        _originalArray = [observationArr copy];
    }
}

- (void)startTraining
{
    if (self.status == LNBouncesOptimizationTrainerStatusTraining) {
        return;
    }
    
    if (!self.originalArray || self.originalArray.count <= 0) {
        return;
    }
    
    __weak LNBouncesOptimizationTrainer *weakSelf = self;
    self.status = LNBouncesOptimizationTrainerStatusTraining;
    dispatch_async(_coculateQueue, ^{
        [weakSelf train];
    });
}

- (void)stopTraining
{
    if (self.status == LNBouncesOptimizationTrainerStatusFree) {
        return;
    }
    
    self.shouldStop = YES;
    __weak LNBouncesOptimizationTrainer *weakSelf = self;
    dispatch_async(_coculateQueue, ^{
        weakSelf.shouldStop = NO;
        weakSelf.status = LNBouncesOptimizationTrainerStatusTraining;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(trainerDidInterrupted)]) {
                weakSelf.status = LNBouncesOptimizationTrainerStatusFree;
                [weakSelf.delegate trainerDidInterrupted];
            }
        });
    });
}

- (void)train
{
    float bias = 1000000000.f;
    
    //v0 = 410.f  A = 426.f;
    //v0 = 2504.f  A = 2493.f
    //v0 = 2661.f  A = 2636.f
    float A = 0.f;
    float Delta = 0.f;
    float Phi = 0.f;
    
    float AStep = 1.f;
    float DeltaStep = 0.01f;
    float PhiStep = 0.001f;
    
    while (1) {
        
        if (self.shouldStop) {
            return;
        }
        
        float tryA1 = A + AStep;
        float bias1 = 0.f;
        
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (Phi + i * 0.0167f);
            float coculateValue = tryA1 * t * expf(-Delta*t);
            bias1 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        float tryA2 = A - AStep;
        float bias2 = 0.f;
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (Phi + i * 0.0167f);
            float coculateValue = tryA2 * t * expf(-Delta*t);
            bias2 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        float tryDelta3 = Delta + DeltaStep;
        float bias3 = 0.f;
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (Phi + i * 0.0167f);
            float coculateValue = A * t * expf(-tryDelta3*t);
            bias3 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        float tryDelta4 = Delta - DeltaStep;
        float bias4 = 0.f;
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (Phi + i * 0.0167f);
            float coculateValue = A * t * expf(-tryDelta4*t);
            bias4 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        
        float tryPhi5 = Phi + PhiStep;
        float bias5 = 0.f;
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (tryPhi5 + i * 0.0167f);
            float coculateValue = A * t * expf(-Delta*t);
            bias5 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        float tryPhi6 = Phi - PhiStep;
        float bias6 = 0.f;
        for (NSInteger i = 0 ; i < self.originalArray.count ; i++) {
            float realValue = [self.originalArray[i] floatValue];
            float t = (tryPhi6 + i * 0.0167f);
            float coculateValue = A * t * expf(-Delta*t);
            bias6 += (coculateValue - realValue)*(coculateValue - realValue);
        }
        
        float chooseBias = MIN(MIN(MIN(bias1, bias2), MIN(bias3, bias4)), MIN(bias5, bias6));
        
        LNBouncesOptimizationTrainerResult *result = [[LNBouncesOptimizationTrainerResult alloc] init];
        result.currentBias = chooseBias;
        
        if (chooseBias > bias) {
            __weak LNBouncesOptimizationTrainer *weakSelf = self;
            result.phi = Phi;
            result.a = A;
            result.delta = Delta;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(trainerDidFinish:)]) {
                    [weakSelf.delegate trainerDidFinish:result];
                }
            });
            break;
        } else {
            bias = chooseBias;
            __weak LNBouncesOptimizationTrainer *weakSelf = self;
            if (chooseBias == bias1) {
                A = tryA1;
            } else if (chooseBias == bias2) {
                A = tryA2;
            } else if (chooseBias == bias3) {
                Delta = tryDelta3;
            } else if (chooseBias == bias4) {
                Delta = tryDelta4;
            } else if (chooseBias == bias5) {
                Phi = tryPhi5;
            } else if (chooseBias == bias6) {
                Phi = tryPhi6;
            } else {
                result.phi = Phi;
                result.a = A;
                result.delta = Delta;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(trainerDidFinish:)]) {
                        [weakSelf.delegate trainerDidFinish:result];
                    }
                });
                break;
            }
            result.phi = Phi;
            result.a = A;
            result.delta = Delta;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(trainerDidUpdate:)]) {
                    [weakSelf.delegate trainerDidUpdate:result];
                }
            });
        }
    }
}

@end

//
//  LNMomentumImpulser.h
//  LNMomentumTransmitDemo
//
//  Created by Levison on 2022/7/17.
//

#import <Foundation/Foundation.h>
#import "LNMomentumObj.h"
#import <UIKit/UIKit.h>
#import "LNRestMomentumDetector.h"

NS_ASSUME_NONNULL_BEGIN

@class LNMomentumImpulser;

@protocol LNMomentumImpulserSerializer <NSObject>

@optional
- (BOOL)impulser:(LNMomentumImpulser *)impulser shouldReactToMomentum:(LNMomentumObj *)momentum;
- (LNMomentumObj *)impulser:(LNMomentumImpulser *)impulser momentumForOriginalMomentum:(LNMomentumObj *)obj;

@end

@interface LNMomentumImpulser : NSObject <LNRestMomentumDelegate>

@property (nonatomic, assign) CGFloat mass;

@property (nonatomic, weak, readonly) UIScrollView *targetScrollView;

@property (nonatomic, weak) id <LNMomentumImpulserSerializer> serializer;

- (instancetype)initWithTargetScrollView:(UIScrollView *)targetScrollView;
- (void)removeCurrentMomentum;

@end

NS_ASSUME_NONNULL_END

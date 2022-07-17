//
//  LNRestMomentumDetector.h
//  LNMomentumTransmitDemo
//
//  Created by Levison on 2022/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LNMomentumObj.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,  LNMomentumEffectDirection)
{
     LNMomentumEffectDirectionVertical,
     LNMomentumEffectDirectionHorizontal
};

@class LNRestMomentumDetector;


@protocol  LNRestMomentumDelegate <NSObject>
@required
- (void)detectorDidReleaseMomentum:(LNMomentumObj *)momentum;

@end

@protocol  LNRestMomentumSerializer <NSObject>

@optional
- (BOOL)detector:(LNRestMomentumDetector *)detector shouldStashMomentum:(LNMomentumObj *)momentum;
- (BOOL)detector:(LNRestMomentumDetector *)detector shouldReleaseMomentum:(LNMomentumObj *)momentum;

@end

@interface  LNRestMomentumDetector : NSObject <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat mass;

@property (nonatomic, assign)  LNMomentumEffectDirection effectDirection;

@property (nonatomic, weak) id< LNRestMomentumDelegate> delegate;
@property (nonatomic, weak) id< LNRestMomentumSerializer> serializer;

@end

NS_ASSUME_NONNULL_END

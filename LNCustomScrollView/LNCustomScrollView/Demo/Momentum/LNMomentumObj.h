//
//  LNMomentumObj.h
//  LNMomentumTransmitDemo
//
//  Created by Levison on 2022/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//只有上下左右，其他方向可以用CGPoint改成单位向量表示
typedef NS_ENUM(NSInteger, LNMomentumDirection)
{
    LNMomentumDirectionLeft,
    LNMomentumDirectionRight,
    LNMomentumDirectionTop,
    LNMomentumDirectionBottom
};

@interface LNMomentumObj : NSObject

@property (nonatomic, assign) float velocityValue;

@property (nonatomic, assign) float mass;

@property (nonatomic, assign, readonly) float momentumValue;

@property (nonatomic, assign) LNMomentumDirection direction;


@end

NS_ASSUME_NONNULL_END

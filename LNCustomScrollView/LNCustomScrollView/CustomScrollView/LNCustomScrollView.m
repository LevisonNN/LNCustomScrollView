//
//  LNCustomScrollView.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNCustomScrollView.h"
#import "LNCustomScrollViewClock.h"

#define BounceDisplaceConvertDelta 0.006f
#define BounceDisplaceConvertC 0.88f
#define BounceDisplaceConvertBias 0.12f

#define MaxIgnoredVelocity 13.f

#define BouncesTimeMultiple 1.1f

@interface LNCustomScrollViewDirectionalStatus: NSObject

@property (nonatomic, assign) CGFloat velocity;

@property (nonatomic, assign) CGFloat position;

@end

@implementation LNCustomScrollViewDirectionalStatus

@end

@interface LNCustomScrollViewDirectionalRange: NSObject

@property (nonatomic, assign) CGFloat minPosition;

@property (nonatomic, assign) CGFloat maxPosition;

@end

@implementation LNCustomScrollViewDirectionalRange

@end

@interface LNCustomScrollView ()
<
LNCustomScrollViewClockProtocol
>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL isTracking;
@property (nonatomic, assign) BOOL tracking;

@property (nonatomic, assign) CGPoint startContentOffset;
@property (nonatomic, assign) CGPoint startPanLocation;

@property (nonatomic, assign) CGPoint velocity;

@property (nonatomic, assign) CGPoint contentOffset;

@end

@implementation LNCustomScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = YES;
        self.velocity = CGPointMake(0.f, 0.f);
        self.contentOffset = CGPointMake(0.f, 0.f);
        [[LNCustomScrollViewClock shareInstance] addObject:self];
        [self addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    self.bounds = CGRectMake(contentOffset.x, contentOffset.y, self.bounds.size.width, self.bounds.size.height);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setContentSize:(CGSize)contentSize
{
    _contentSize = contentSize;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealWithPanEvent:)];
    }
    return _panGesture;
}

- (void)dealWithPanEvent:(UIPanGestureRecognizer *)panGesture
{
    if (self.panGesture.state == UIGestureRecognizerStateBegan) {
        self.startContentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y);
        self.startPanLocation = [self.panGesture translationInView:self];
        self.isTracking = YES;
    } else if (self.panGesture.state == UIGestureRecognizerStateChanged) {
        self.isTracking = YES;
        CGPoint currentPanLocation = [self.panGesture translationInView:self];
        
        CGFloat targetX = self.startContentOffset.x - (currentPanLocation.x - self.startPanLocation.x);
        CGFloat targetY = self.startContentOffset.y - (currentPanLocation.y - self.startPanLocation.y);
        
        if (!self.bounces) {
            targetX = [self getInsideXOf:targetX];
            targetY = [self getInsideYOf:targetY];
        } else {
            targetX = [self getBouncesXOf:targetX];
            targetY = [self getBouncesYOf:targetY];
        }
        
        self.contentOffset = CGPointMake(targetX, targetY);
    } else {
        //possible
        self.isTracking = NO;
        
        self.startPanLocation = CGPointZero;
        self.startContentOffset = CGPointZero;
    }
}

- (void)customScrollViewClockUpdateTimeInterval:(NSTimeInterval)time
{
    if (CGPointEqualToPoint(CGPointZero, self.velocity) &&
        self.contentOffset.y > 0.f &&
        self.contentOffset.y < self.contentSize.height - self.bounds.size.height &&
        self.contentOffset.x > 0.f &&
        self.contentOffset.x < self.contentSize.width - self.bounds.size.width) {
        return;
    }
    
    if (!self.isTracking) {
        //检查是否有剩余动画
        if (fabs(self.velocity.x) > MaxIgnoredVelocity || self.contentOffset.x < 0.f || self.contentOffset.x > self.contentSize.width - self.bounds.size.width) {
            LNCustomScrollViewDirectionalStatus *status = [[LNCustomScrollViewDirectionalStatus alloc] init];
            status.position = self.contentOffset.x;
            status.velocity = self.velocity.x;
            LNCustomScrollViewDirectionalRange *range = [[LNCustomScrollViewDirectionalRange alloc] init];
            range.minPosition = 0.f;
            range.maxPosition = MAX(self.contentSize.width - self.bounds.size.width, 0.f);
            LNCustomScrollViewDirectionalStatus *resultStatus = [self stepFromStatus:status inRange:range afterDuring:time bounces:YES];
            
            self.velocity = CGPointMake(resultStatus.velocity, self.velocity.y);
            self.contentOffset = CGPointMake(resultStatus.position, self.contentOffset.y);
        } else {
            self.velocity = CGPointMake(0.f, self.velocity.y);
        }
        
        if (fabs(self.velocity.y) > MaxIgnoredVelocity || self.contentOffset.y < 0.f || self.contentOffset.y > self.contentSize.height - self.bounds.size.height) {
            LNCustomScrollViewDirectionalStatus *status = [[LNCustomScrollViewDirectionalStatus alloc] init];
            status.position = self.contentOffset.y;
            status.velocity = self.velocity.y;
            LNCustomScrollViewDirectionalRange *range = [[LNCustomScrollViewDirectionalRange alloc] init];
            range.minPosition = 0.f;
            range.maxPosition = MAX(self.contentSize.height - self.bounds.size.height, 0.f);
            LNCustomScrollViewDirectionalStatus *resultStatus = [self stepFromStatus:status inRange:range afterDuring:time bounces:YES];
            
            self.velocity = CGPointMake(self.velocity.x, resultStatus.velocity);
            self.contentOffset = CGPointMake(self.contentOffset.x, resultStatus.position);
        } else {
            self.velocity = CGPointMake(self.velocity.x, 0.f);
        }
    } else {
    }
}

- (LNCustomScrollViewDirectionalStatus *)stepFromStatus:(LNCustomScrollViewDirectionalStatus *)status
                                              inRange:(LNCustomScrollViewDirectionalRange *)range
                                          afterDuring:(NSTimeInterval)during
                                              bounces:(BOOL)bounces
{
    CGFloat originalVelocity = status.velocity;
    CGFloat originalPosition = status.position;
    
    LNCustomScrollViewDirectionalStatus *resultStatus = [[LNCustomScrollViewDirectionalStatus alloc] init];
    
    //先区分所在位置
    if (originalPosition < range.minPosition) {
        //在顶端
        CGFloat distanceToBalancePoint = range.minPosition - originalPosition;
        CGFloat velocity = originalVelocity;
        
        if (fabs(velocity) == 0) {
            velocity = +0;
        }
        
        NSTimeInterval t;
        if (velocity/distanceToBalancePoint > -10.9) {
            t = 1.f/(10.9 + velocity/distanceToBalancePoint);
            CGFloat A = distanceToBalancePoint/(t * exp(-10.9 * t));
            NSTimeInterval targetT = t + during * BouncesTimeMultiple;
            
            CGFloat targetVelocity = A * exp(-10.9 * targetT) + A * targetT * (-10.9) * exp(-10.9 * targetT);
            CGFloat targetPosition = A * targetT * exp(-10.9 * targetT);
            resultStatus.velocity =  targetVelocity;
            resultStatus.position = range.minPosition - targetPosition;
            
            if (velocity < MaxIgnoredVelocity && distanceToBalancePoint < 1.f) {
                resultStatus.position = range.minPosition;
                resultStatus.velocity = 0.f;
            }
        } else {
            resultStatus.position = range.minPosition;
            resultStatus.velocity = 0.f;
        }
        
    } else if (originalPosition > range.maxPosition) {
        //在底端
        CGFloat distanceToBalancePoint = originalPosition - range.maxPosition;
        CGFloat velocity = originalVelocity;
        
        if (fabs(velocity) == 0) {
            velocity = +0;
        }
        
        NSTimeInterval t;
        if (velocity/distanceToBalancePoint > -10.9f) {
            t = 1.f/(10.9 + velocity/distanceToBalancePoint);
            CGFloat A = distanceToBalancePoint/(t * exp(-10.9 * t));
            NSTimeInterval targetT = t + during * BouncesTimeMultiple;
            
            CGFloat targetVelocity = A * exp(-10.9 * targetT) + A * targetT * (-10.9) * exp(-10.9 * targetT);
            CGFloat targetPosition = A * targetT * exp(-10.9 * targetT);
            resultStatus.velocity =  targetVelocity;
            resultStatus.position = range.maxPosition + targetPosition;
            
            if (velocity < MaxIgnoredVelocity && distanceToBalancePoint < 1.f) {
                resultStatus.position = range.maxPosition;
                resultStatus.velocity = 0.f;
            }
        } else {
            resultStatus.position = range.maxPosition;
            resultStatus.velocity = 0.f;
        }
    } else {
        //在中央
        
        CGFloat estimatedVelocity = exp(log(fabs(originalVelocity))- 2*during) * (originalVelocity > 0.f ? 1.f:(-1.f));
        CGFloat estimatedDistance = fabs(estimatedVelocity - originalVelocity)/2.f * (originalVelocity > 0.f ? 1.f:(-1.f));
        CGFloat estimatedPosition = originalPosition + estimatedDistance;
        
        
        //这个运动被分为两段decelerate，减速和bounces
        if (estimatedPosition < range.minPosition) {
            CGFloat restDistance = fabs(originalPosition - range.minPosition);
            CGFloat v0 = fabs(originalVelocity) - restDistance * 2.f;
            
            CGFloat decelerateT = log(v0/(restDistance + v0))/2.f;
            
            CGFloat bouncesT = MAX(0, during - decelerateT);
            
            CGFloat bouncesDistance = v0 * bouncesT * exp(- 10.9 * bouncesT);
            CGFloat targetPosition = range.minPosition - bouncesDistance;
            
            CGFloat targetVelocity = v0*exp(-10.9*bouncesT) + v0*bouncesT*(-10.9)*exp(-10.9*bouncesT);
            
            if (!self.bounces) {
                resultStatus.position = range.minPosition;
                resultStatus.velocity = 0.f;
            } else {
                if (fabs(targetVelocity) > MaxIgnoredVelocity) {
                    resultStatus.position = targetPosition;
                    resultStatus.velocity = targetVelocity;
                } else {
                    resultStatus.position = range.minPosition;
                    resultStatus.velocity = 0.f;
                }
            }

        } else if (estimatedPosition > range.maxPosition) {
            CGFloat restDistance = fabs(originalPosition - range.maxPosition);
            CGFloat v0 = fabs(originalVelocity) - restDistance * 2.f;
            
            CGFloat decelerateT = log(v0/(restDistance + v0))/2.f;
            
            CGFloat bouncesT = MAX(0, during - decelerateT);
            
            CGFloat bouncesDistance = v0 * bouncesT * exp(- 10.9 * bouncesT);
            CGFloat targetPosition = range.maxPosition + bouncesDistance;
            
            CGFloat targetVelocity = v0*exp(-10.9*bouncesT) + v0*bouncesT*(-10.9)*exp(-10.9*bouncesT);
            
            
            if (!self.bounces) {
                resultStatus.position = range.maxPosition;
                resultStatus.velocity = 0.f;
            } else {
                if (fabs(targetVelocity) > MaxIgnoredVelocity) {
                    resultStatus.position = targetPosition;
                    resultStatus.velocity = targetVelocity;
                } else {
                    resultStatus.position = range.maxPosition;
                    resultStatus.velocity = 0.f;
                }
            }

        } else {
            //正常的减速
            resultStatus.position = estimatedPosition;
            resultStatus.velocity = estimatedVelocity;
        }
    }
    
    return resultStatus;
}

- (CGFloat)getInsideXOf:(CGFloat)targetX
{
    
    if (targetX < 0.f) {
        targetX = 0.f;
    }
    
    if (targetX > self.contentSize.width - self.frame.size.width) {
        if (self.contentSize.width - self.frame.size.width > 0.f) {
            targetX = self.contentSize.width - self.frame.size.width;
        } else {
            targetX = 0.f;
        }
    }
    return targetX;
}

- (CGFloat)getInsideYOf:(CGFloat)targetY
{
    
    if (targetY < 0.f) {
        targetY = 0.f;
    }
    
    if (targetY > self.contentSize.height - self.frame.size.height) {
        if (self.contentSize.height - self.frame.size.height > 0.f) {
            targetY = self.contentSize.height - self.frame.size.height;
        } else {
            targetY = 0.f;
        }
    }
    return targetY;
}


- (CGFloat)getBouncesXOf:(CGFloat)targetX
{
    if (targetX < 0.f) {
        CGFloat resultX = BounceDisplaceConvertC * (1/BounceDisplaceConvertDelta) * (1 - exp(-BounceDisplaceConvertDelta * fabs(targetX))) + BounceDisplaceConvertBias *fabs(targetX);
        return -resultX;
    } else if (targetX > self.contentSize.width - self.frame.size.width) {
        CGFloat displace = targetX - (self.contentSize.width - self.frame.size.width);
        CGFloat resultDisplace = BounceDisplaceConvertC *(1/BounceDisplaceConvertDelta) * (1 - exp(-BounceDisplaceConvertDelta * fabs(displace))) + BounceDisplaceConvertBias * fabs(displace);
        CGFloat resultX = (self.contentSize.width - self.frame.size.width) + resultDisplace;
        return resultX;
    } else {
        return targetX;
    }
}

- (CGFloat)getBouncesYOf:(CGFloat)targetY
{
    if (targetY < 0.f) {
        CGFloat resultY = BounceDisplaceConvertC * (1/BounceDisplaceConvertDelta) * (1 - exp(-BounceDisplaceConvertDelta * fabs(targetY))) + BounceDisplaceConvertBias *fabs(targetY);
        return -resultY;
    } else if (targetY > self.contentSize.height - self.frame.size.height) {
        CGFloat displace = targetY - (self.contentSize.height - self.frame.size.height);
        CGFloat resultDisplace = BounceDisplaceConvertC * (1/BounceDisplaceConvertDelta) * (1 - exp(-BounceDisplaceConvertDelta * fabs(displace))) +  BounceDisplaceConvertBias * fabs(displace);
        CGFloat resultY = (self.contentSize.height - self.frame.size.height) + resultDisplace;
        return resultY;
    } else {
        return targetY;
    }
}

- (void)setIsTracking:(BOOL)isTracking
{
    _isTracking = isTracking;
    if (_isTracking != self.tracking) {
        self.tracking = _isTracking;
    }
}

- (void)setTracking:(BOOL)tracking
{
    _tracking = tracking;
    if (tracking) {
        //停止所有动画
        self.velocity = CGPointZero;
        
    } else {
        //检查有没有没做完的动画
        CGPoint velocity = [self.panGesture velocityInView:self];
        
        CGFloat velocityX = velocity.x;
        if (self.contentSize.width <= self.bounds.size.width) {
            velocityX = 0.f;
        }
        
        if (self.contentOffset.x < 0 || self.contentOffset.x > self.contentSize.width) {
            velocityX = 0.f;
        }
        
        CGFloat velocityY = velocity.y;
        if (self.contentSize.height <= self.bounds.size.height) {
            velocityY = 0.f;
        }
        
        if (self.contentOffset.y < 0 || self.contentOffset.y > self.contentSize.height) {
            velocityY = 0.f;
        }
        
        self.velocity = CGPointMake(- velocityX,  - velocityY);

        //NSLog(@"%lf,%lf",velocity.x, velocity.y);
    }
}

@end


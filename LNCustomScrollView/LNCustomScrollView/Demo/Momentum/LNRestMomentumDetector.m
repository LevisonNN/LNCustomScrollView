//
//  LNRestMomentumDetector.m
//  LNMomentumTransmitDemo
//
//  Created by Levison on 2022/7/17.
//

#import "LNRestMomentumDetector.h"

@interface LNRestMomentumDetector ()

@property (nonatomic, strong) LNMomentumObj *stashedMomentum;

@end

@implementation LNRestMomentumDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mass = 1;
    }
    return self;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.effectDirection == LNMomentumEffectDirectionHorizontal) {
        CGFloat targetOffset = scrollView.contentOffset.x + (velocity.x * 1000.f - 13.f)/2.f;
        if (fabs(targetOffset - targetContentOffset->x) > 13.f) {
            CGFloat v = fabs(targetOffset - targetContentOffset->x)*2 + 13.f;
            LNMomentumObj *stashedMomentum = [[LNMomentumObj alloc] init];
            stashedMomentum.velocityValue = v;
            stashedMomentum.mass = self.mass;
            stashedMomentum.direction = velocity.x > 0?LNMomentumDirectionRight:LNMomentumDirectionLeft;
            self.stashedMomentum = stashedMomentum;
        }
    } else {
        CGFloat targetOffset = scrollView.contentOffset.y + (velocity.y * 1000.f - 13.f)/2.f;
         if (fabs(targetOffset - targetContentOffset->y) > 13.f) {
             CGFloat v = fabs(targetOffset - targetContentOffset->y)*2 + 13.f;
             LNMomentumObj *stashedMomentum = [[LNMomentumObj alloc] init];
             stashedMomentum.velocityValue = v;
             stashedMomentum.mass = self.mass;
             stashedMomentum.direction = velocity.y > 0?LNMomentumDirectionBottom:LNMomentumDirectionTop;
             self.stashedMomentum = stashedMomentum;
         }
    }
}

- (void)setStashedMomentum:(LNMomentumObj *)stashedMomentum
{
    if (self.serializer && [self.serializer respondsToSelector:@selector(detector:shouldStashMomentum:)]) {
        if ([self.serializer detector:self shouldStashMomentum:stashedMomentum]) {
            _stashedMomentum = stashedMomentum;
        }
    } else {
        _stashedMomentum = stashedMomentum;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.stashedMomentum) {
        if (self.serializer && [self.serializer respondsToSelector:@selector(detector:shouldReleaseMomentum:)]) {
            if ([self.serializer detector:self shouldReleaseMomentum:self.stashedMomentum]) {
                [self.delegate detectorDidReleaseMomentum:self.stashedMomentum];
            }
        } else {
            [self.delegate detectorDidReleaseMomentum:self.stashedMomentum];
        }
        _stashedMomentum = nil;
    }
}

@end

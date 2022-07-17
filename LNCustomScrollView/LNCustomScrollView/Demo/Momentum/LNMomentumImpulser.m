//
//  LNMomentumImpulser.m
//  LNMomentumTransmitDemo
//
//  Created by Levison on 2022/7/17.
//

#import "LNMomentumImpulser.h"
#import "LNVelocityDynamicItem.h"

@interface LNMomentumImpulser ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, weak) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) LNVelocityDynamicItem *velocityItem;

@property (nonatomic, assign) CGPoint stashedContentOffset;

@property (nonatomic, weak) UIScrollView *targetScrollView;

@end

@implementation LNMomentumImpulser

- (instancetype)initWithTargetScrollView:(UIScrollView *)targetScrollView
{
    self = [super init];
    if (self) {
        self.targetScrollView = targetScrollView;
        self.mass = 1;
        _velocityItem = [[LNVelocityDynamicItem alloc] init];
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:targetScrollView];
    }
    return self;
}

- (void)detectorDidReleaseMomentum:(LNMomentumObj *)momentum
{
    if (self.serializer && [self.serializer respondsToSelector:@selector(impulser:shouldReactToMomentum:)] && (![self.serializer impulser:self shouldReactToMomentum:momentum])) {
        return;
    }
    
    if (self.serializer && [self.serializer respondsToSelector:@selector(impulser:momentumForOriginalMomentum:)]) {
        momentum = [self.serializer impulser:self momentumForOriginalMomentum:momentum];
    }
    
    if (!momentum) {
        return;
    }
    
    if (self.targetScrollView && self.mass != 0) {
        self.stashedContentOffset = self.targetScrollView.contentOffset;
        switch (momentum.direction) {
            case LNMomentumDirectionLeft: {
                [self pulseHorizontalVelocity:-momentum.momentumValue/self.mass resistance:2.f];
            } break;
            case LNMomentumDirectionRight: {
                [self pulseHorizontalVelocity:momentum.momentumValue/self.mass resistance:2.f];
            } break;
            case LNMomentumDirectionTop: {
                [self pulseVerticalVelocity:-momentum.momentumValue/self.mass resistance:2.f];
            } break;
            case LNMomentumDirectionBottom: {
                [self pulseVerticalVelocity:momentum.momentumValue/self.mass resistance:2.f];
            } break;
            default:
                break;
        }
    }
}

- (void)removeCurrentMomentum
{
    [self.animator removeAllBehaviors];
    self.decelerationBehavior = nil;
}

- (void)pulseHorizontalVelocity:(CGFloat)velocity resistance:(CGFloat)resistance
{
    if (!self.targetScrollView) {
        return;
    }
    
    if ([self.targetScrollView isMemberOfClass:[UIScrollView class]]) {
        return;
    }
    
    [self removeCurrentMomentum];
    
    self.velocityItem.center = self.targetScrollView.contentOffset;
    UIDynamicItemBehavior *decelerationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.velocityItem]];
    [decelerationBehavior addLinearVelocity:CGPointMake(velocity, 0) forItem:self.velocityItem];
    decelerationBehavior.resistance = 2.0;

    __weak LNMomentumImpulser *weakSelf = self;
    decelerationBehavior.action = ^{
        if (weakSelf.targetScrollView.tracking || weakSelf.targetScrollView.dragging || weakSelf.targetScrollView.decelerating || (!weakSelf.targetScrollView.scrollEnabled)) {
            [weakSelf.animator removeAllBehaviors];
        } else if (fabs(weakSelf.stashedContentOffset.x - weakSelf.targetScrollView.contentOffset.x) > 1.f) {
            [weakSelf.animator removeAllBehaviors];
        } else if (weakSelf.velocityItem.center.x < 0) {
            [weakSelf.animator removeAllBehaviors];
            weakSelf.targetScrollView.contentOffset = CGPointMake(0, weakSelf.targetScrollView.contentOffset.y);
        } else if (weakSelf.velocityItem.center.x > weakSelf.targetScrollView.contentSize.width - weakSelf.targetScrollView.frame.size.width) {
            [weakSelf.animator removeAllBehaviors];
            weakSelf.targetScrollView.contentOffset = CGPointMake(MAX(weakSelf.targetScrollView.contentSize.width - weakSelf.targetScrollView.frame.size.width, 0), weakSelf.targetScrollView.contentOffset.y) ;
        } else {
            CGPoint contentOffset = weakSelf.targetScrollView.contentOffset;
            contentOffset = weakSelf.velocityItem.center;
            weakSelf.targetScrollView.contentOffset = contentOffset;
            weakSelf.stashedContentOffset = contentOffset;
        }
        
        if (fabs([weakSelf.decelerationBehavior linearVelocityForItem:weakSelf.velocityItem].x)< 13.f) {
            [weakSelf.animator removeAllBehaviors];
        }
    };

    [self.animator addBehavior:decelerationBehavior];
    self.decelerationBehavior = decelerationBehavior;
}

- (void)pulseVerticalVelocity:(CGFloat)velocity resistance:(CGFloat)resistance
{
    if (!self.targetScrollView) {
        return;
    }
    
    if ([self.targetScrollView isMemberOfClass:[UIScrollView class]]) {
        return;
    }
    
    [self removeCurrentMomentum];

    self.velocityItem.center = self.targetScrollView.contentOffset;
    UIDynamicItemBehavior *decelerationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.velocityItem]];
    [decelerationBehavior addLinearVelocity:CGPointMake(0, velocity) forItem:self.velocityItem];
    decelerationBehavior.resistance = 2.0;

    __weak LNMomentumImpulser *weakSelf = self;
    decelerationBehavior.action = ^{
        if (weakSelf.targetScrollView.tracking || weakSelf.targetScrollView.dragging || weakSelf.targetScrollView.decelerating || (!weakSelf.targetScrollView.scrollEnabled)) {
            [weakSelf.animator removeAllBehaviors];
        } else if (fabs(weakSelf.stashedContentOffset.y - weakSelf.targetScrollView.contentOffset.y) > 1.f) {
            [weakSelf.animator removeAllBehaviors];
        } else if (weakSelf.velocityItem.center.y < - weakSelf.targetScrollView.contentInset.top) {
            [weakSelf.animator removeAllBehaviors];
            weakSelf.targetScrollView.contentOffset = CGPointMake(weakSelf.targetScrollView.contentOffset.x, - weakSelf.targetScrollView.contentInset.top);
        } else if (weakSelf.velocityItem.center.y > weakSelf.targetScrollView.contentSize.height + weakSelf.targetScrollView.contentInset.bottom - weakSelf.targetScrollView.frame.size.height) {
            [weakSelf.animator removeAllBehaviors];
            weakSelf.targetScrollView.contentOffset = CGPointMake(weakSelf.targetScrollView.contentOffset.x, MAX( weakSelf.targetScrollView.contentSize.height + weakSelf.targetScrollView.contentInset.bottom - weakSelf.targetScrollView.frame.size.height, 0)) ;
        } else {
            CGPoint contentOffset = weakSelf.targetScrollView.contentOffset;
            contentOffset = weakSelf.velocityItem.center;
            weakSelf.targetScrollView.contentOffset = contentOffset;
            weakSelf.stashedContentOffset = contentOffset;
        }
        
        if (fabs([weakSelf.decelerationBehavior linearVelocityForItem:weakSelf.velocityItem].y) < 13.f) {
            [weakSelf.animator removeAllBehaviors];
        }
    };

    [self.animator addBehavior:decelerationBehavior];
    self.decelerationBehavior = decelerationBehavior;
}

@end

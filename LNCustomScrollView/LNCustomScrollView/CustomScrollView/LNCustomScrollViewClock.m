//
//  LNCustomScrollViewClock.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNCustomScrollViewClock.h"
#import "LNCustomScrollViewClockProxy.h"
#import <QuartzCore/QuartzCore.h>


@interface LNCustomScrollViewClock ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CFTimeInterval realWorldTime;

@property (nonatomic, assign) CGFloat speedScale;

@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, assign) NSTimeInterval allTime;

@property (nonatomic, strong) NSHashTable<id <LNCustomScrollViewClockProtocol>> *hashTable;

@end

@implementation LNCustomScrollViewClock

- (instancetype)init
{
    self = [super init];
    if (self) {
        _realWorldTime = CACurrentMediaTime();
        _speedScale = 1.f;
        _isPaused = YES;
    }
    return self;
}

- (void)addObject:(id<LNCustomScrollViewClockProtocol>)obj
{
    [self.hashTable addObject:obj];
    
}

+ (instancetype)shareInstance
{
    static LNCustomScrollViewClock* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
             shareInstance = [[LNCustomScrollViewClock alloc] init];
        }
    });
    return shareInstance;
}

- (void)dealloc
{
    [self stop];
}

- (void)resetClock
{
    [self stop];
    self.realWorldTime = CACurrentMediaTime();
    self.speedScale = 1.f;
    self.isPaused = NO;
    _displayLink = [CADisplayLink displayLinkWithTarget:[LNCustomScrollViewClockProxy proxyWithTarget:self] selector:@selector(callback)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)callback
{
    CFTimeInterval newRealWorldTime = CACurrentMediaTime();
    CFTimeInterval timeInterval = newRealWorldTime - self.realWorldTime;
    for (id <LNCustomScrollViewClockProtocol> obj in self.hashTable) {
        if ([obj respondsToSelector:@selector(customScrollViewClockUpdateTimeInterval:)]) {
            [obj customScrollViewClockUpdateTimeInterval:timeInterval];
        }
    }
    self.realWorldTime = newRealWorldTime;
}

- (void)startOrResume
{
    if (!_displayLink) {
        [self resetClock];
    }
    if (self.isPaused) {
        self.isPaused = NO;
    }
}

- (void)pause
{
    self.isPaused = YES;
}

- (void)stop
{
    self.isPaused = YES;
    [_displayLink invalidate];
    _displayLink = nil;
}

- (NSHashTable *)hashTable
{
    if (!_hashTable) {
        _hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:2];
    }
    return _hashTable;
}

@end

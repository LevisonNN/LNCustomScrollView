//
//  LNCustomScrollViewClock.h
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNCustomScrollViewClockProtocol <NSObject>

- (void)customScrollViewClockUpdateTimeInterval:(NSTimeInterval)time;

@end

@interface LNCustomScrollViewClock : NSObject

+ (instancetype)shareInstance;

- (void)addObject:(id <LNCustomScrollViewClockProtocol>)obj;

@property (nonatomic, assign, readonly) BOOL isPaused;

- (void)startOrResume;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END

//
//  DemoItemObj.h
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DemoType)
{
    DemoTypeDecelerateObservation,
    DemoTypeBouncesObservation,
    DemoTypePanGestureObservation,
    DemoTypeOptimization,
    DemoTypeCustomScrollView,
    DemoTypeMomentumTransmit,
};

@interface DemoItemObj : NSObject

@property (nonatomic, assign) DemoType type;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

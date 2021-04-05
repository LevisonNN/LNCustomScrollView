//
//  DemoItemCollectionViewCell.h
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoItemObj.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kDemoItemCollectionViewCell;

@interface DemoItemCollectionViewCell : UICollectionViewCell

- (void)setItemObj:(DemoItemObj *)item;

@end

NS_ASSUME_NONNULL_END

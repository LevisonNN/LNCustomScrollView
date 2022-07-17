//
//  MomentumTransmitViewController.h
//  LNCustomScrollView
//
//  Created by Levison on 17.7.22.
//  Copyright © 2022 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//横向的UICollectionView（v1）的右侧和纵向UICollectionView（v2）的顶部进行了连接
//v1的向右的剩余速度会转成v2向下的剩余速度。反之，v2的向上剩余速度会转成v1向左的剩余速度。
//如果你需要两个纵向的列表v1嵌套v2，只做单向的就可以，将v1撞击底部的剩余速度转成v2向下的剩余速度
//因为视图方向不一致，所以需要serializer过滤器将不同方向的速度转换一下。
//我们强制加上的效果优先级总是最低的任何用户操作/函数调用都会让这个失效，所以不用担心它对其他效果造成影响。
//它要求UIScrollView的bounces=NO，因为一份能量不能转化为两份（被bounces里的阻尼消耗+传递给其他视图）。


@interface MomentumTransmitViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

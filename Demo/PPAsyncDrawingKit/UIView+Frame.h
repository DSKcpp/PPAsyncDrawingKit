//
//  UIView+Frame.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@end

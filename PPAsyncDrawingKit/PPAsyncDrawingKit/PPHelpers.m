//
//  PPHelpers.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/3/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPHelpers.h"

CGFloat PPScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

CGColorSpaceRef PPColorSpaceCreateDeviceRGB() {
    static CGColorSpaceRef colorSpaceRef;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpaceRef;
}

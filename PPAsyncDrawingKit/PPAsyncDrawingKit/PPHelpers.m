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
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

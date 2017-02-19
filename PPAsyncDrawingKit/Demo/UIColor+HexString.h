//
//  UIColor+HexString.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/19.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

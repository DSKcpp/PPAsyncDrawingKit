//
//  UIColor+HexString.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/19.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    NSUInteger hexValue =  strtoul([hexString UTF8String], 0, 16);
    UIColor *color = [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16) / 255.0f
                                     green:((hexValue & 0x00FF00) >> 8) / 255.0f
                                      blue:((hexValue & 0x0000FF) >> 0) / 255.0f
                                     alpha:alpha];
    return color;
}
@end

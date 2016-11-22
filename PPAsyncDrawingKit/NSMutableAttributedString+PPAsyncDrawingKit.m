//
//  NSMutableAttributedString+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSMutableAttributedString+PPAsyncDrawingKit.h"

@implementation NSMutableAttributedString (PPAsyncDrawingKit)
- (void)pp_setColor:(UIColor *)color
{
    [self pp_setColor:color inRange:[self pp_stringRange]];
}

- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (!color) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
    } else {
        // WBTextDefaultForegroundColorAttributeName
        [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:range];
    }
}

- (void)pp_setCTFont:(CTFontRef)CTFont
{
    [self pp_setCTFont:CTFont inRange:[self pp_stringRange]];
}

- (void)pp_setCTFont:(CTFontRef)CTFont inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (CTFont) {
        [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id _Nonnull)(CTFont) range:range];
    } else {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
    }
}

- (void)pp_setBackgroundColor:(UIColor *)backgroundColor inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (backgroundColor) {
        [self addAttribute:@"PPTextBackgroundColorAttributeName" value:backgroundColor range:range];
    } else {
        [self removeAttribute:@"PPTextBackgroundColorAttributeName" range:range];
    }
}

- (NSRange)pp_stringRange
{
    return NSMakeRange(0, self.length);
}

- (NSRange)pp_effectiveRangeWithRange:(NSRange)range
{
    NSUInteger max = range.location + range.length;
    if (max > self.length) {
        return NSMakeRange(0, self.length);
    } else if (max == self.length) {
        return range;
    }
    return range;
}

@end

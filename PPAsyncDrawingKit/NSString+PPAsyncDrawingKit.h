//
//  NSString+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (PPAsyncDrawingKit)
#pragma mark - Regex
- (BOOL)pp_isMatchedByRegex:(NSString *)regex;
- (BOOL)pp_isMatchedByRegex:(NSString *)regex inRange:(NSRange)range;
- (BOOL)pp_isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError **)error;
- (void)pp_enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString *capturedString, NSRange capturedRange, BOOL *stop))block;

#pragma mark - Drawing
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment inContext:(CGContextRef)context;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLines:(NSUInteger)numberOfLines inContext:(CGContextRef)context;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;

#pragma mark - Size
- (CGSize)pp_sizeWithFont:(UIFont *)font;
- (CGSize)pp_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width;
- (CGSize)pp_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)pp_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)pp_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end

//
//  NSMutableAttributedString+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (PPAsyncDrawingKit)
@property (nonatomic, strong) UIFont *pp_font;
@property (nonatomic, assign) CGFloat pp_lineHeight;
@property (nonatomic, assign) CGFloat pp_kerning;
@property (nonatomic, assign) NSTextAlignment pp_alignment;
+ (instancetype)stringWithString:(NSString *)string;
- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight;
- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)pp_setLineHeight:(CGFloat)lineHeight inRange:(NSRange)range;
- (void)pp_setCTFont:(CTFontRef)CTFont;
- (void)pp_setKerning:(CGFloat)kerning inRange:(NSRange)range;
- (void)pp_setBackgroundColor:(UIColor *)backgroundColor inRange:(NSRange)range;
- (void)pp_setColor:(UIColor *)color;
- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range;
- (void)pp_setCTFont:(CTFontRef)CTFont inRange:(NSRange)range;
- (void)pp_setFont:(UIFont *)font inRange:(NSRange)range;
- (NSRange)pp_effectiveRangeWithRange:(NSRange)range;
- (NSRange)pp_stringRange;
@end

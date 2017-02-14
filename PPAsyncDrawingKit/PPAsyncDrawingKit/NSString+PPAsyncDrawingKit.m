//
//  NSString+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSString+PPAsyncDrawingKit.h"
#import "NSAttributedString+PPExtendedAttributedString.h"
#import "PPTextFontMetrics.h"

@implementation NSString (PPAsyncDrawingKit)
- (BOOL)pp_isMatchedByRegex:(NSString *)regex
{
    return [self pp_isMatchedByRegex:regex inRange:NSMakeRange(0, self.length)];
}

- (BOOL)pp_isMatchedByRegex:(NSString *)regex inRange:(NSRange)range
{
    return [self pp_isMatchedByRegex:regex options:kNilOptions inRange:range error:nil];
}

- (BOOL)pp_isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError *__autoreleasing *)error
{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:options error:error];
    if (error) {
        NSLog(@"Regex Error: %@", *error);
        return NO;
    }
    NSTextCheckingResult *result = [regular firstMatchInString:regex options:kNilOptions range:range];
    return result != nil;
}

- (void)pp_enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString * _Nonnull, NSRange, BOOL * _Nonnull))block
{
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Regex Error: %@", error);
    }
    [regular enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *subText = [self substringWithRange:result.range];
        block(subText, result.range, stop);
    }];
}

- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor
{
    return [self pp_drawInRect:rect withFont:font textColor:textColor lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft numberOfLines:0 inContext:UIGraphicsGetCurrentContext()];
}

- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self pp_drawInRect:rect withFont:font textColor:textColor lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft numberOfLines:0 inContext:UIGraphicsGetCurrentContext()];
}

- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    return [self pp_drawInRect:rect withFont:font textColor:textColor lineBreakMode:lineBreakMode alignment:alignment numberOfLines:0 inContext:UIGraphicsGetCurrentContext()];
}

- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment  inContext:(CGContextRef)context
{
    return [self pp_drawInRect:rect withFont:font textColor:textColor lineBreakMode:lineBreakMode alignment:alignment numberOfLines:0 inContext:context];
}
- (CGSize)pp_drawInRect:(CGRect)rect withFont:(UIFont *)font textColor:(UIColor *)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLines:(NSUInteger)numberOfLines inContext:(CGContextRef)context
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString pp_setFont:font];
    [attributedString pp_setColor:textColor];
    [attributedString pp_setAlignment:alignment lineBreakMode:lineBreakMode lineHeight:0];
    return [attributedString pp_drawInRect:rect context:context numberOfLines:numberOfLines];
}

- (CGSize)pp_sizeWithFont:(UIFont *)font
{
    return [self pp_sizeWithFont:font constrainedToSize:CGSizeZero lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)pp_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width
{
    return [self pp_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)pp_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self pp_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)pp_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self pp_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)pp_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    if (!font) {
        font = [UIFont systemFontOfSize:15.0f];
    }
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return result;
}
@end

//
//  NSAttributedString+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "PPTextRenderer.h"
#import "PPTextAttachment.h"

static void PPRunDelegateDeallocCallback(void *ref) { }

static CGFloat PPRunDelegateGetAscentCallback(void *ref) {
    
    UIImage *image = (__bridge UIImage *)(ref);
    if ([image isKindOfClass:[UIImage class]]) {
        return image.size.height;
    }
    return 0.0f;
}

static CGFloat PPRunDelegateGetDecentCallback(void *ref) {
    
    return 0;
}

static CGFloat PPRunDelegateGetWidthCallback(void *ref) {
    UIImage *image = (__bridge UIImage *)(ref);
    if ([image isKindOfClass:[UIImage class]]) {
        return image.size.width;
    }
    return 0.0f;
}

@implementation NSAttributedString (PPAsyncDrawingKit)
- (NSRange)pp_stringRange
{
    return NSMakeRange(0, self.length);
}

+ (PPTextRenderer *)rendererForCurrentThread
{
    NSString *key = @"com.dskcpp.PPAsyncDrawingKit.thread-textrenderer";
    PPTextRenderer *textRenderer = [[NSThread currentThread] pp_objectWithAssociatedKey:&key];
    if (!textRenderer) {
        textRenderer = [[PPTextRenderer alloc] init];
        [[NSThread currentThread] pp_setObject:textRenderer forAssociatedKey:&key retained:YES];
    }
    return textRenderer;
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width
{
    return [self pp_heightConstrainedToWidth:width exclusionPaths:nil];
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width exclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    PPTextLayout *textLayout = [NSAttributedString rendererForCurrentThread].textLayout;
    textLayout.maximumNumberOfLines = 0;
    textLayout.attributedString = self;
    textLayout.exclusionPaths = exclusionPaths;
    textLayout.size = CGSizeMake(width, 20000);
    return textLayout.layoutHeight;
}

- (CGSize)pp_sizeConstrainedToWidth:(CGFloat)width
{
    return [self pp_sizeConstrainedToSize:CGSizeMake(width, 20000)];
}

- (CGSize)pp_sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines
{
    return [self pp_sizeConstrainedToSize:CGSizeMake(width, 20000) numberOfLines:numberOfLines];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size
{
    return [self pp_sizeConstrainedToSize:size numberOfLines:0];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines
{
    return [self pp_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:0];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount
{
    PPFontMetrics fontMetrics;
    return [self pp_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:derivedLineCount baselineMetrics:fontMetrics];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount baselineMetrics:(PPFontMetrics)baselineMetrics
{
    PPTextLayout *textLayout = [NSAttributedString rendererForCurrentThread].textLayout;
    textLayout.attributedString = self;
    textLayout.size = size;
    textLayout.maximumNumberOfLines = numberOfLines;
    textLayout.baselineFontMetrics = baselineMetrics;
    CGSize resultSize;
    if (textLayout) {
        resultSize = textLayout.layoutSize;
    } else {
        resultSize = CGSizeZero;
    }
    //    textLayout.containingLineCount
    return resultSize;
}

- (NSRange)pp_rangeToSize:(CGSize)size
{
    PPTextRenderer *textRenderer = [NSAttributedString rendererForCurrentThread];
    textRenderer.attributedString = self;
    textRenderer.frame = CGRectMake(0, 0, size.width, size.height);
    PPTextLayout *textLayout = textRenderer.textLayout;
    textLayout.maximumNumberOfLines = 0;
    return textLayout.containingStringRange;
}

- (NSRange)pp_rangeToSize:(CGSize)size withLimitedLines:(NSUInteger)limitedLines
{
    PPTextRenderer *textRenderer = [NSAttributedString rendererForCurrentThread];
    textRenderer.attributedString = self;
    textRenderer.frame = CGRectMake(0, 0, size.width, size.height);
    PPTextLayout *textLayout = textRenderer.textLayout;
    return [textLayout containingStringRangeWithLineLimited:limitedLines];
}

+ (instancetype)pp_attributedStringWithTextAttachment:(PPTextAttachment *)textAttachment
{
    return [self pp_attributedStringWithTextAttachment:textAttachment attributes:nil];
}

+ (instancetype)pp_attributedStringWithTextAttachment:(PPTextAttachment *)textAttachment attributes:(NSDictionary *)attributes
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = PPRunDelegateDeallocCallback;
    callbacks.getAscent = PPRunDelegateGetAscentCallback;
    callbacks.getDescent = PPRunDelegateGetDecentCallback;
    callbacks.getWidth = PPRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(textAttachment.contents));
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    attr[@"PPTextAttachmentAttributeName"] = textAttachment;
    attr[(NSString *)kCTForegroundColorAttributeName] = (__bridge id _Nullable)([UIColor clearColor].CGColor);
    attr[(NSString *)kCTRunDelegateAttributeName] = (__bridge id)runDelegate;
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    return [[[self class] alloc] initWithString:content attributes:attr];
}
@end

@implementation NSMutableAttributedString (PPAsyncDrawingKit)

- (void)setAttribute:(NSString *)name value:(id)value {
    [self setAttribute:name value:value range:self.pp_stringRange];
}

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range
{
    if (!name) {
        return ;
    }
    range = [self pp_effectiveRangeWithRange:range];
    if (value) {
        [self addAttribute:name value:value range:range];
    } else {
        [self removeAttribute:name range:range];
    }
}
- (void)pp_setColor:(UIColor *)color
{
    [self pp_setColor:color inRange:[self pp_stringRange]];
}

- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range
{
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

- (void)pp_setFont:(UIFont *)font
{
    [self pp_setFont:font inRange:[self pp_stringRange]];
}

- (void)pp_setFont:(UIFont *)font inRange:(NSRange)range
{
    [self setAttribute:NSFontAttributeName value:font range:range];
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

- (NSRange)pp_effectiveRangeWithRange:(NSRange)range
{
    NSUInteger max = range.location + range.length;
    if (max > self.length) {
        return NSMakeRange(range.location, range.length);
    }
    return range;
}

@end

//
//  NSAttributedString+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "PPTextRenderer.h"

@implementation NSAttributedString (PPAsyncDrawingKit)
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

+ (PPTextRenderer *)pp_sharedTextRenderer
{
    return [self rendererForCurrentThread];
}

- (PPTextRenderer *)pp_sharedTextRenderer
{
    return [[self class] pp_sharedTextRenderer];
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width
{
    return [self pp_heightConstrainedToWidth:width exclusionPaths:nil];
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width exclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    PPTextLayout *textLayout = [self pp_sharedTextRenderer].textLayout;
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
    PPTextLayout *textLayout = [self pp_sharedTextRenderer].textLayout;
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
    PPTextRenderer *textRenderer = [self pp_sharedTextRenderer];
    textRenderer.attributedString = self;
    textRenderer.frame = CGRectMake(0, 0, size.width, size.height);
    PPTextLayout *textLayout = textRenderer.textLayout;
    textLayout.maximumNumberOfLines = 0;
    return textLayout.containingStringRange;
}

- (NSRange)pp_rangeToSize:(CGSize)size withLimitedLines:(NSUInteger)limitedLines
{
    PPTextRenderer *textRenderer = [self pp_sharedTextRenderer];
    textRenderer.attributedString = self;
    textRenderer.frame = CGRectMake(0, 0, size.width, size.height);
    PPTextLayout *textLayout = textRenderer.textLayout;
    return [textLayout containingStringRangeWithLineLimited:limitedLines];
}
@end

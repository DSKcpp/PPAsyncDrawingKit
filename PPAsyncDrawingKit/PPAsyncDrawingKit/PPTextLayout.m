//
//  PPTextLayout.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayout.h"
#import <objc/objc-sync.h>
#import "PPTextLayoutLine.h"
#import "PPTextFontMetrics.h"

@interface PPTextLayout ()
{
    BOOL _needsLayout;
}
@end

@implementation PPTextLayout
- (instancetype)init
{
    if (self = [super init]) {
        _needsLayout = YES;
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
{
    if (self = [self init]) {
        self.attributedString = attributedString;
    }
    return self;
}

- (PPTextLayoutFrame *)layoutFrame
{
    if (_needsLayout || _layoutFrame == nil) {
        @synchronized (self) {
            _layoutFrame = [self createLayoutFrame];
        }
        _needsLayout = NO;
    }
    return _layoutFrame;
}

- (PPTextLayoutFrame *)createLayoutFrame
{
    PPTextLayoutFrame *textLayoutFrame;
    if (self.attributedString.length > 0) {
        CGMutablePathRef mutablePath;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
        if (self.exclusionPaths.count) {
            
        } else {
            mutablePath = CGPathCreateMutable();
            CGRect rect = CGRectMake(0, 0, self.size.width, 20000);
            CGAffineTransform transform = CGAffineTransformIdentity;
            CGPathAddRect(mutablePath, &transform, rect);
        }
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.length), mutablePath, NULL);
        CGPathRelease(mutablePath);
        CFRelease(framesetter);
        if (frame) {
            textLayoutFrame = [[PPTextLayoutFrame alloc] initWithCTFrame:frame layout:self];
            CFRelease(frame);
        }
    }
    return textLayoutFrame;
}

- (void)setNeedsLayout
{
    _needsLayout = YES;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        @synchronized (self) {
            _attributedString = attributedString;
        }
        _needsLayout = YES;
    }
}

- (void)setExclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    if (_exclusionPaths != exclusionPaths) {
        _exclusionPaths = exclusionPaths;
        _needsLayout = YES;
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        _needsLayout = YES;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        _needsLayout =YES;
    }
}

@end

@implementation PPTextLayout (LayoutResult)
- (NSUInteger)containingLineCount
{
    return self.layoutFrame.lineFragments.count;
}

- (CGFloat)layoutHeight
{
    return self.layoutSize.height;
}

- (CGSize)layoutSize
{
    if (self.layoutFrame) {
        return self.layoutFrame.layoutSize;
    } else {
        return CGSizeZero;
    }
}

- (NSRange)containingStringRange
{
    return [self containingStringRangeWithLineLimited:0];
}

- (NSRange)containingStringRangeWithLineLimited:(NSUInteger)lineLimited
{
    NSUInteger count = self.layoutFrame.lineFragments.count;
    NSRange range;
    if (count) {
        PPTextLayoutLine *line;
        if (count >= lineLimited) {
            line = self.layoutFrame.lineFragments[lineLimited];
        } else {
            line = self.layoutFrame.lineFragments.lastObject;
        }
        range = line.stringRange;
    }
    return range;
}

- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index
{
    CGRect rect = [self boundingRectForCharacterRange:NSMakeRange(index, 0)];
    CGFloat x = CGRectGetMaxX(rect);
    CGFloat y = CGRectGetMaxY(rect);
    return CGPointMake(x, y);
}

- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range
{
    return [self.layoutFrame firstSelectionRectForCharacterRange:range];
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    return [self enumerateSelectionRectsForCharacterRange:range usingBlock:nil];
}

- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index
{
    return [self.layoutFrame lineFragmentIndexForCharacterAtIndex:index];
}

- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    NSUInteger idx = [self lineFragmentIndexForCharacterAtIndex:index];
    return [self lineFragmentRectForLineAtIndex:idx effectiveRange:range];
}

- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    NSArray<PPTextLayoutLine *> *lineFragments = self.layoutFrame.lineFragments;
    if (lineFragments.count >= index) {
        PPTextLayoutLine *line = lineFragments[index];
        return line.fragmentRect;
    } else {
        return CGRectNull;
    }
}

- (PPTextFontMetrics *)lineFragmentMetricsForLineAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    PPTextFontMetrics *fontMetrics;
    NSArray<PPTextLayoutLine *> *lineFragments = self.layoutFrame.lineFragments;
    if (lineFragments.count >= index) {
        PPTextLayoutLine *line = lineFragments[index];
        fontMetrics = line.lineMetrics;
    }
    return fontMetrics;
}

- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(nullable void (^)(CGRect, BOOL * _Nonnull))block
{
    return [self.layoutFrame enumerateSelectionRectsForCharacterRange:range usingBlock:block];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    [self.layoutFrame enumerateEnclosingRectsForCharacterRange:range usingBlock:block];
}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, NSRange, BOOL * _Nonnull))block
{
    [self.layoutFrame enumerateLineFragmentsForCharacterRange:range usingBlock:block];
}
@end

@implementation PPTextLayout (Coordinates)
- (CGPoint)convertPointToCoreText:(CGPoint)point
{
    return CGPointMake(point.x, self.size.height - point.y);
}

- (CGPoint)convertPointFromCoreText:(CGPoint)point
{
    return CGPointMake(point.x, self.size.height - point.y);
}

- (CGRect)convertRectToCoreText:(CGRect)rect
{
    CGPoint point = [self convertPointToCoreText:rect.origin];
    rect.origin = point;
    return rect;
}

- (CGRect)convertRectFromCoreText:(CGRect)rect
{
    CGPoint point = [self convertPointFromCoreText:rect.origin];
    rect.origin = point;
    return rect;
}
@end

@implementation PPTextLayout (HitTesting)
- (NSRange)characterRangeForBoundingRect:(CGRect)rect
{
    CGFloat x = CGRectGetMaxX(rect);
    CGFloat y = CGRectGetMaxY(rect);
    CGPoint point = CGPointMake(x, y);
    NSUInteger location  = [self characterIndexForPoint:rect.origin];
    NSUInteger right = [self characterIndexForPoint:point];
    return NSMakeRange(location, right - location);
}

- (NSUInteger)characterIndexForPoint:(CGPoint)point
{
    __block NSUInteger loc;
    [self.layoutFrame.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        loc = [line characterIndexForBoundingPosition:point];
    }];
    return loc;
}

@end

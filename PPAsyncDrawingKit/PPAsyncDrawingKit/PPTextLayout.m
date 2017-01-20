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

- (PPTextRenderer *)textRenderer
{
    if (!_textRenderer) {
        _textRenderer = [PPTextRenderer textRendererWithTextLayout:self];
    }
    return _textRenderer;
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

//- (void)setSize:(CGSize)size
//{
//    if (!CGSizeEqualToSize(_size, size)) {
//        _size = size;
//        _needsLayout = YES;
//    }
//}
//
//- (void)setOrigin:(CGPoint)origin
//{
//    
//}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(_frame, frame)) {
        _frame = frame;
        _needsLayout = YES;
    }
}

- (CGPoint)origin
{
    return _frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    if (!CGPointEqualToPoint(_frame.origin, origin)) {
        _frame.origin = origin;
        _needsLayout = YES;
    }
}

- (CGSize)size
{
    return _frame.size;
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_frame.size, size)) {
        _frame.size = size;
        _needsLayout = YES;
    }
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines
{
    if (_numberOfLines != numberOfLines) {
        _numberOfLines = numberOfLines;
        _needsLayout = YES;
    }
}

@end

@implementation PPTextLayout (PPTextLayoutResult)
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

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    [self.layoutFrame enumerateEnclosingRectsForCharacterRange:range usingBlock:block];
}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, NSRange, BOOL * _Nonnull))block
{
    [self.layoutFrame enumerateLineFragmentsForCharacterRange:range usingBlock:block];
}
@end

@implementation PPTextLayout (PPTextLayoutCoordinates)
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

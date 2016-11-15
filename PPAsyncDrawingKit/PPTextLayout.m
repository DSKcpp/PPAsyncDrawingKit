//
//  PPTextLayout.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayout.h"
#import <objc/objc-sync.h>

@implementation PPTextLayout
{
    struct {
        unsigned int needsLayout: 1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
        flags.needsLayout = 1;
        PPFontMetrics fontMetrics;
        self.baselineFontMetrics = fontMetrics;
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
    if (flags.needsLayout != 0 || _layoutFrame == nil) {
        @synchronized (self) {
            _layoutFrame = [self createLayoutFrame];
        }
        flags.needsLayout = 0;
    }
    return _layoutFrame;
}

- (PPTextLayoutFrame *)createLayoutFrame
{
    if (self.attributedString) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
        if (self.exclusionPaths.count != 0) {
            [self.exclusionPaths enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [path appendPath:obj.copy];
                [path applyTransform:transform];
            }];
            path.usesEvenOddFillRule = YES;
        } else {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, &transform, CGRectZero);
        }
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.length), path.CGPath, NULL);
        CFRelease(framesetter);
        if (frame) {
            PPTextLayoutFrame *textLayoutFrame = [[PPTextLayoutFrame alloc] initWithCTFrame:frame layout:self];
//            CFRelease(frame);
            return textLayoutFrame;
        }
        return nil;
    } else {
        return nil;
    }
}

- (void)setNeedsLayout
{
    flags.needsLayout = 1;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        @synchronized (self) {
            _attributedString = attributedString;
        }
        flags.needsLayout = 1;
    }
}

- (void)setExclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    if (_exclusionPaths != exclusionPaths) {
        _exclusionPaths = exclusionPaths;
        flags.needsLayout = 1;
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        flags.needsLayout = 1;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        flags.needsLayout = 1;
    }
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
@end

//
//  PPTextLayoutLine.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayoutLine.h"
#import "PPAsyncDrawingKitUtilities.h"
#import "PPTextLayout.h"

@interface PPTextLayoutLine ()
@property (nonatomic, assign) NSRange lineRefRange;
@end

@implementation PPTextLayoutLine
- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout
{
    return [self initWithCTLine:lineRef origin:origin layout:layout truncatedLine:nil];
}

- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout truncatedLine:(CTLineRef)truncatedLine
{
    if (self = [super init]) {
        _baselineOrigin = origin;
        _layout = layout;
        if (lineRef) {
            _lineRef = CFRetain(lineRef);
            CFRange range = CTLineGetStringRange(lineRef);
            _stringRange = PPNSRangeFromCFRange(range);
            _lineRefRange = PPNSRangeFromCFRange(range);
            [self setupWithCTLine];
        }
    }
    return self;
}

- (void)setupWithCTLine
{
    PPFontMetrics fontMetrics;
    if (_layout) {
        fontMetrics = _layout.baselineFontMetrics;
        _baselineOrigin = [_layout convertPointFromCoreText:_baselineOrigin];
    }
    _width = CTLineGetTypographicBounds(_lineRef, &fontMetrics.ascent, &fontMetrics.descent, &fontMetrics.leading);
    _lineMetrics = fontMetrics;
}

- (CGRect)fragmentRect
{
    CGFloat height = _lineMetrics.ascent + _lineMetrics.descent;
    return (CGRect){_baselineOrigin, (CGSize){_width, height}};
}

- (void)dealloc
{
    if (_lineRef) {
        CFRelease(_lineRef);
    }
}

- (void)enumerateLayoutRunsUsingBlock:(void (^)(NSDictionary *, NSRange))block
{
    if (block && _lineRef) {
        CFArrayRef runs = CTLineGetGlyphRuns(_lineRef);
        CFIndex count = CFArrayGetCount(runs);
        for (NSInteger i = 0; i < count; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            NSRange range = PPNSRangeFromCFRange(CTRunGetStringRange(run));
            block(attributes, range);
        }
    }
    //    [self locationDeltaFromRealRangeToLineRefRange];
}

- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)index
{
    if (_lineRef) {
        NSInteger idx = [self locationDeltaFromRealRangeToLineRefRange];
        if (idx > index) {
            idx = index;
        }
        return CTLineGetOffsetForStringIndex(_lineRef, index - idx, NULL);
    } else {
        return 0.0f;
    }
}

- (NSInteger)locationDeltaFromRealRangeToLineRefRange
{
    if (_lineRef) {
        NSInteger i = _stringRange.location - _lineRefRange.location;
        if (i < 0) {
            return 0;
        }
        return i;
    } else {
        return 0;
    }
}

- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)index
{
    CGPoint point = _baselineOrigin;
    if (_lineRef) {
        CGFloat x = [self offsetXForCharacterAtIndex:index];
        return CGPointMake(x, point.y);
    }
    return point;
}

- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position
{
    if (_lineRef) {
        [self locationDeltaFromRealRangeToLineRefRange];
        return CTLineGetStringRange(_lineRef).length;
    } else {
        return _stringRange.length;
    }
}
@end

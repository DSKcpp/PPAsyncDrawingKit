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

@implementation PPTextLayoutLine
{
    NSRange lineRefRange;
}

- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout
{
    return [self initWithCTLine:lineRef origin:origin layout:layout truncatedLine:nil];
}

- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout truncatedLine:(CTLineRef)truncatedLine
{
    if (self = [super init]) {
        _originalBaselineOrigin = origin;
        if (lineRef) {
            _lineRef = lineRef;
            CFRange range = CTLineGetStringRange(lineRef);
            _stringRange = NSRangeFromCFRange(range);
            lineRefRange = NSRangeFromCFRange(range);
            [self setupWithCTLine];
        }
        
    }
    return self;
}

- (void)setupWithCTLine
{
//    CTLineGetTypographicBounds(_lineRef, <#CGFloat * _Nullable ascent#>, <#CGFloat * _Nullable descent#>, <#CGFloat * _Nullable leading#>)
}

- (CGRect)originalFragmentRect
{
    CGFloat height = self.originalLineMetrics.ascent + self.originalLineMetrics.descent + self.originalLineMetrics.leading;
    return CGRectIntegral((CGRect){self.originalBaselineOrigin, (CGSize){self.width, ceilf(height)}});
}

- (CGRect)fragmentRect
{
    CGFloat height = self.lineMetrics.ascent + self.lineMetrics.descent + self.lineMetrics.leading;
    return CGRectIntegral((CGRect){self.baselineOrigin, (CGSize){self.width, ceilf(height)}});
}


- (void)dealloc
{
    if (_lineRef) {
        CFRelease(_lineRef);
        _lineRef = nil;
    }
}
@end

@implementation PPTextLayoutLine (LayoutResult)
- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)index
{
    if (_lineRef) {
        NSInteger idx = [self locationDeltaFromRealRangeToLineRefRange];
        if (idx > index) {
            
        }
        return CTLineGetOffsetForStringIndex(_lineRef, idx, NULL);
    } else {
        return 0.0f;
    }
}

- (NSInteger)locationDeltaFromRealRangeToLineRefRange
{
    if (_lineRef) {
        return lineRefRange.length - _stringRange.length;
    } else {
        return 0;
    }
}

- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)index
{
    CGPoint point = self.baselineOrigin;
    if (_lineRef) {
        NSInteger index = [self locationDeltaFromRealRangeToLineRefRange];
        return CGPointMake(CTLineGetOffsetForStringIndex(_lineRef, index, NULL), point.y);
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

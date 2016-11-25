//
//  PPTextLayoutFrame.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayoutFrame.h"
#import "PPTextLayout.h"
#import "PPTextLayoutLine.h"

@implementation PPTextLayoutFrame

- (instancetype)initWithCTFrame:(CTFrameRef)frame layout:(PPTextLayout *)layout
{
    if (self = [super init]) {
        if (layout) {
            self.layout = layout;
            [self setupWithCTFrame:frame];
        }
    }
    return self;
}

- (void)setupWithCTFrame:(CTFrameRef)frame
{
    NSInteger maxLines = self.layout.maximumNumberOfLines;

    CFArrayRef lineRefs = CTFrameGetLines(frame);
    if (maxLines == 0) {
        maxLines = CFArrayGetCount(lineRefs);
    }
    CGPoint origins[maxLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    NSMutableArray *lines = [NSMutableArray array];
    
    for (NSInteger i = 0; i < maxLines; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
        PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:origins[i] layout:self.layout];
        [lines addObject:line];
    }
    self.lineFragments = lines;
    [self updateLayoutSize];
}

- (void)updateLayoutSize
{
    if (self.lineFragments.count) {
        __block CGFloat height = 0.0f;
        __block CGFloat width = 0.0f;
        [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
            height += line.fragmentRect.size.height;
            width = MAX(width, line.fragmentRect.size.width);
        }];
        self.layoutSize = CGSizeMake(width, height);
    }
}

- (id)textLayout:(PPTextLayout *)layout truncateLine:(CTLineRef)truncateLine atIndex:(NSUInteger)index truncated:(BOOL)truncated
{
    return nil;
}


- (CGFloat)textLayout:(PPTextLayout *)layout maximumWidthForTruncatedLine:(CTLineRef)maximumWidthForTruncatedLine atIndex:(NSUInteger)index
{
    if ([layout.delegate respondsToSelector:@selector(textLayout:maximumWidthForLineTruncationAtIndex:)]) {
        return [layout.delegate textLayout:layout maximumWidthForLineTruncationAtIndex:index];
    } else {
        return layout.size.width;
    }
}

@end

@implementation PPTextLayoutFrame (LayoutResult)
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range
{
    [self enumerateSelectionRectsForCharacterRange:range usingBlock:^{
        
    }];
    return CGRectZero;
}

- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    return 0;
}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
//        line.fragmentRect;
//        line.stringRange;
    }];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    if (block) {
        if (self.lineFragments.count) {
            [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
                if (range.location >= line.stringRange.location && (range.location + range.length) <= line.stringRange.location + line.stringRange.length) {
                    CGFloat x = [line offsetXForCharacterAtIndex:range.location + range.length];
                    CGRect rect = line.fragmentRect;
                    rect.origin.x = x;
                    block(rect, stop);
                }
            }];
        }
    }
}

- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
{
//    [self enumerateEnclosingRectsForCharacterRange:range usingBlock:^{
//        
//    }];
    return CGRectZero;
}

@end

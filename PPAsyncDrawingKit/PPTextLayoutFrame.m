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
    CFIndex lineCount = CFArrayGetCount(lineRefs);
    NSMutableArray *lines = [NSMutableArray array];
//    CGRect rect = CGRectZero;
    if (lineCount > 0) {
//        CGPoint *origins = malloc(lineCount * sizeof(CGPoint));
        CGPoint origins[lineCount];
        CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), origins);
        
        for (NSInteger i = 0; i < lineCount; i++) {
            CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
            if (maxLines == 0) {
                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:origins[i] layout:self.layout];
                [lines addObject:line];
            } else if (maxLines - 1 != 0) {
//                CTLineRef truncateLine = [self textLayout:_layout truncateLine:lineRef atIndex:maxLines - 1 truncated:YES];
//                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:truncateLine origin:origins[i] layout:_layout];
//                [lines addObject:line];
            } else {
                CTLineRef truncateLine = [self textLayout:_layout truncateLine:lineRef atIndex:maxLines - 1 truncated:YES];
                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:truncateLine origin:origins[i] layout:_layout];
                [lines addObject:line];
            }
        }
    }
    self.lineFragments = [NSArray arrayWithArray:lines];
//    self.layoutSize = rect.size;
    [self updateLayoutSize];
}

- (void)updateLayoutSize
{
    if (_lineFragments.count) {
        __block CGRect rect = CGRectZero;
        [_lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                rect = line.fragmentRect;
            } else {
                rect = CGRectUnion(rect, line.fragmentRect);
            }
        }];
        self.layoutSize = rect.size;
    }
}


- (CTLineRef)textLayout:(PPTextLayout *)layout truncateLine:(CTLineRef)truncateLine atIndex:(NSUInteger)index truncated:(BOOL)truncated
{
    if (truncateLine) {
        CFRange stringRange = CTLineGetStringRange(truncateLine);
        CGFloat maxWidth = [self textLayout:layout maximumWidthForTruncatedLine:truncateLine atIndex:index];
        CGFloat width = CTLineGetTypographicBounds(truncateLine, NULL, NULL, NULL);
        if (width < maxWidth) {
            return truncateLine;
        }
        NSAttributedString *attributedString = layout.attributedString;
        NSDictionary<NSString *, id> *truncateTokenAttributes = [attributedString attributesAtIndex:stringRange.location effectiveRange:nil];
        NSArray *keys = @[(id)kCTForegroundColorAttributeName, (id)kCTFontAttributeName, (id)kCTParagraphStyleAttributeName];
        truncateTokenAttributes = [truncateTokenAttributes dictionaryWithValuesForKeys:keys];
//        [truncateTokenAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            
//        }];
        NSAttributedString *tokenAttrStr;
        if (layout.truncationString) {
            tokenAttrStr = layout.truncationString;
        } else {
            tokenAttrStr = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:truncateTokenAttributes];
        }
        CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenAttrStr);
        NSMutableAttributedString *resultAttrStr = [attributedString attributedSubstringFromRange:PPNSRangeFromCFRange(stringRange)].mutableCopy;
        [resultAttrStr appendAttributedString:tokenAttrStr];
        
        CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)resultAttrStr);
        
        CTLineRef resuleLineRef = CTLineCreateTruncatedLine(lineRef, maxWidth, kCTLineTruncationEnd, truncationToken);
        CFRelease(truncationToken);
        if (!resuleLineRef) {
            resuleLineRef = CFRetain(lineRef);
        }
        CFRelease(lineRef);
        return resuleLineRef;
    }
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
//    [self enumerateSelectionRectsForCharacterRange:range usingBlock:^{
//        
//    }];
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
            __block CGFloat y = 0;
            [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (range.location >= line.stringRange.location && (range.location + range.length) <= line.stringRange.location + line.stringRange.length) {
                NSRange lineRange = line.stringRange;
                if (range.location >= lineRange.location) {
                    if (range.length + range.location <= lineRange.length + lineRange.location) {
                        CGFloat left = [line offsetXForCharacterAtIndex:range.location];
                        CGFloat right = [line offsetXForCharacterAtIndex:range.location + range.length];
                        CGRect rect = CGRectMake(left, (line.fragmentRect.size.height + 1) * idx, right - left, line.fragmentRect.size.height);
                        block(rect, stop);
                    }
                }

//                }
            }];
        }
    }
}

- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(nullable void (^)(CGRect, BOOL * _Nonnull))block
{
    CGRect rects = CGRectZero;
    [self enumerateEnclosingRectsForCharacterRange:range usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
        CGRectUnion(rects, rect);
    }];
    return rects;
}

@end

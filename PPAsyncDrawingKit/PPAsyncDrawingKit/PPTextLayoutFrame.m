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
#import "PPTextUtilties.h"
#import "PPTextFontMetrics.h"
#import "NSAttributedString+PPExtendedAttributedString.h"

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
    NSInteger maxLines = self.layout.numberOfLines;
    CFArrayRef lineRefs = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lineRefs);
    NSMutableArray *lines = [NSMutableArray array];
    if (lineCount > 0) {
        CGPoint origins[lineCount];
        CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), origins);
        
        for (NSInteger i = 0; i < lineCount; i++) {
            CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
            CGPoint position = origins[i];
            position.y = 20000 - position.y;
            if (maxLines == 0 || i != maxLines - 1) {
                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:position layout:self.layout];
                [lines addObject:line];
            } else {
                CTLineRef truncatedLine = [self createTruncatedLine:self.layout lastLineRef:lineRef];
                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:truncatedLine origin:position layout:self.layout];
                [lines addObject:line];
                break;
            }
        }
    }
    self.lineFragments = [NSArray arrayWithArray:lines];
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
        CGSize size = rect.size;
        size.width = ceil(size.width);
        size.height = ceil(size.height);
        self.layoutSize = size;
    }
}


- (CTLineRef)createTruncatedLine:(PPTextLayout *)layout lastLineRef:(CTLineRef)lastLineRef
{
    if (!lastLineRef) {
        return nil;
    }
    
    CFRange stringRange = CTLineGetStringRange(lastLineRef);
    if (PPNSRangeEnd(PPNSRangeFromCFRange(stringRange)) >= layout.attributedString.length) {
        return lastLineRef;
    }
    
    CGFloat maxWidth = layout.maxSize.width;
    NSAttributedString *attributedString = layout.attributedString;
    NSAttributedString *truncateToken;
    if (layout.truncationString) {
        truncateToken = layout.truncationString;
    } else {
        NSDictionary<NSString *, id> *truncateTokenAttributes = [attributedString attributesAtIndex:stringRange.location effectiveRange:nil];
        NSArray *keys = @[(id)kCTForegroundColorAttributeName, (id)kCTFontAttributeName, (id)kCTParagraphStyleAttributeName];
        truncateTokenAttributes = [truncateTokenAttributes dictionaryWithValuesForKeys:keys];
        NSMutableDictionary *finalTokenAttributes = @{}.mutableCopy;
        [truncateTokenAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj != [NSNull null]) {
                finalTokenAttributes[key] = obj;
            }
        }];
        truncateToken = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:finalTokenAttributes];
    }
    
    CTLineRef truncateTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncateToken);
    
    NSMutableAttributedString *lastLineAttrStr = [attributedString attributedSubstringFromRange:PPNSRangeFromCFRange(stringRange)].mutableCopy;
    [lastLineAttrStr appendAttributedString:truncateToken];
    
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)lastLineAttrStr);
    
    CTLineRef resuleLineRef = CTLineCreateTruncatedLine(lineRef, maxWidth, kCTLineTruncationEnd, truncateTokenLine);
    CFRelease(truncateTokenLine);
    if (!resuleLineRef) {
        resuleLineRef = CFRetain(lineRef);
    }
    CFRelease(lineRef);
    return resuleLineRef;
}

@end

@implementation PPTextLayoutFrame (LayoutResult)

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, NSRange, BOOL * _Nonnull))block
{
    if (!block) {
        return;
    }
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        block(line.fragmentRect, line.stringRange, stop);
    }];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    if (!block) {
        return;
    }
    if (self.lineFragments.count) {
        [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange lineRange = line.stringRange;
            if (PPNSRangeStart(range) <= PPNSRangeEnd(lineRange)) {
                if (PPNSRangeStart(lineRange) <= PPNSRangeEnd(range)) {
                    CGFloat x = line.baselineOrigin.x;
                    CGFloat y = line.baselineOrigin.y;
                    CGFloat left = [line offsetXForCharacterAtIndex:range.location] + x;
                    CGFloat right = [line offsetXForCharacterAtIndex:range.location + range.length] + x;
                    CGRect rect = CGRectMake(left, y - line.lineMetrics.ascent, right - left, line.fragmentRect.size.height);
                    block(rect, stop);
                }
            }
        }];
    }
}

@end

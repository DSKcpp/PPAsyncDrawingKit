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
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    NSMutableArray *lines = [NSMutableArray array];
    
    for (NSInteger i = 0; i < lineCount; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
        PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:origins[i] layout:self.layout];
        [lines addObject:line];
    }
    self.lineFragments = lines;
}

- (void)updateLayoutSize
{
    
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
//- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range
//{
//    [self enumerateSelectionRectsForCharacterRange:range usingBlock:^{
//        
//    }];
//}

//- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index
//{
//    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
//}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        line.fragmentRect;
        line.stringRange;
    }];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)arg1 usingBlock:(void (^)(void))block
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

//- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
//{
//    [self enumerateEnclosingRectsForCharacterRange:range usingBlock:^{
//        
//    }];
//}

@end

//
//  PPTextLayout.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPTextLayoutFrame.h"

@protocol PPTextLayoutDelegate <NSObject>
@optional
- (CGFloat)textLayout:(PPTextLayout *)layout maximumWidthForLineTruncationAtIndex:(NSUInteger)index;
@end

@interface PPTextLayout : NSObject
@property(nonatomic, assign) BOOL retriveFontMetricsAutomatically;
@property(nonatomic, weak) id <PPTextLayoutDelegate> delegate;
@property(nonatomic, assign) PPTFontMetrics baselineFontMetrics;
@property(nonatomic, strong) NSAttributedString *truncationString;
@property(nonatomic, assign) NSUInteger maximumNumberOfLines;
@property(nonatomic, strong) NSArray *exclusionPaths;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, strong) NSAttributedString *attributedString;
@property(nonatomic, strong) PPTextLayoutFrame *layoutFrame;

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString;
- (id)createLayoutFrame;
@end


@interface PPTextLayout (Coordinates)
- (CGRect)convertRectToCoreText:(CGRect)rect;
- (CGRect)convertRectFromCoreText:(CGRect)rect;
- (CGPoint)convertPointToCoreText:(CGPoint)point;
- (CGPoint)convertPointFromCoreText:(CGPoint)point;
@end

@interface PPTextLayout (HitTesting)
- (NSUInteger)characterIndexForPoint:(CGPoint)point;
- (NSRange)characterRangeForBoundingRect:(CGRect)rect;
@end

@interface PPTextLayout (LayoutResult)
@property(readonly, nonatomic) CGFloat layoutHeight;
@property(readonly, nonatomic) CGSize layoutSize;
@property(readonly, nonatomic) NSUInteger containingLineCount;
@property(readonly, nonatomic) NSRange containingStringRange;
@property(readonly, nonatomic) BOOL layoutUpToDate;
- (CGRect)boundingRectForCharacterRange:(NSRange)range;
- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index;
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(id)block;
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)arg1 usingBlock:(id)block;
- (void)enumerateLineFragmentsForCharacterRange:(NSRange)arg1 usingBlock:(id)block;
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)arg1;
- (PPTFontMetrics)lineFragmentMetricsForLineAtIndex:(NSUInteger)index effectiveRange:(NSRange)range;
- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)arg1 effectiveRange:(NSRange)range;
- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)arg1 effectiveRange:(NSRange)range;
- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index;
- (NSRange)containingStringRangeWithLineLimited:(NSUInteger)lineLimited;
@end

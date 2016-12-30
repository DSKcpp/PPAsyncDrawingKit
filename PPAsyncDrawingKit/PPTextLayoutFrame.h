//
//  PPTextLayoutFrame.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "PPAsyncDrawingKitUtilities.h"

@class PPTextLayout;
@class PPTextLayoutLine;

NS_ASSUME_NONNULL_BEGIN

@interface PPTextLayoutFrame : NSObject
@property (nonatomic, weak) PPTextLayout *layout;
@property (nonatomic, assign) CGSize layoutSize;
@property (nonatomic, assign) PPFontMetrics baselineMetrics;
@property (nullable, nonatomic, strong) NSArray<PPTextLayoutLine *> *lineFragments;

- (instancetype)initWithCTFrame:(CTFrameRef)frame layout:(PPTextLayout *)layout;
- (void)setupWithCTFrame:(CTFrameRef)frame;
- (CTLineRef)textLayout:(PPTextLayout *)layout truncateLine:(CTLineRef)truncateLine atIndex:(NSUInteger)index truncated:(BOOL)truncated;
- (CGFloat)textLayout:(PPTextLayout *)layout maximumWidthForTruncatedLine:(CTLineRef)maximumWidthForTruncatedLine atIndex:(NSUInteger)index;
@end

@interface PPTextLayoutFrame (LayoutResult)
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(CGRect rect, BOOL *stop))block;
- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range;
- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END

//
//  PPTextLayoutLine.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "PPTextLayoutFrame.h"

@interface PPTextLayoutLine : NSObject
@property (nonatomic, assign) CTLineRef lineRef;
@property (nonatomic, assign) CGFloat width;
@property (readonly, nonatomic, assign) BOOL truncated;
@property (readonly, nonatomic, assign) PPFontMetrics lineMetrics;
@property (readonly, nonatomic, assign) PPFontMetrics originalLineMetrics;
@property (readonly, nonatomic, assign) NSRange stringRange;
@property (readonly, nonatomic, assign) CGPoint baselineOrigin;
@property (readonly, nonatomic, assign) CGPoint originalBaselineOrigin;
@property (nonatomic, weak) PPTextLayout *layout;

@property (nonatomic, assign, readonly) CGRect fragmentRect;
@property (nonatomic, assign, readonly) CGRect originalFragmentRect;
- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout;
- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout truncatedLine:(CTLineRef)truncatedLine;
- (void)setupWithCTLine;
@end

@interface PPTextLayoutLine (LayoutResult)
//- (void)enumerateLayoutRunsUsingBlock:(CDUnknownBlockType)arg1;
- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position;
- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)index;
- (NSInteger)locationDeltaFromRealRangeToLineRefRange;
- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)index;
@end

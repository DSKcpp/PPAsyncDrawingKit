//
//  PPTextLayoutLine.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class PPTextLayout;
@class PPTextFontMetrics;

NS_ASSUME_NONNULL_BEGIN

@interface PPTextLayoutLine : NSObject
@property (nonatomic, assign, readonly) CTLineRef lineRef;
@property (nonatomic, strong, readonly) PPTextFontMetrics *lineMetrics;
@property (nonatomic, assign, readonly) BOOL truncated;
@property (nonatomic, assign, readonly) NSRange stringRange;
@property (nonatomic, assign, readonly) CGPoint baselineOrigin;
@property (nonatomic, assign, readonly) CGRect fragmentRect;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, weak, readonly) PPTextLayout *layout;

- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout;
- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout
                 truncatedLine:(nullable CTLineRef)truncatedLine;
- (void)setupWithCTLine;

- (void)enumerateLayoutRunsUsingBlock:(void(^)(NSDictionary *attributes, NSRange range))block;

- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position;
- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)index;
- (NSInteger)locationDeltaFromRealRangeToLineRefRange;
- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)index;
@end


NS_ASSUME_NONNULL_END

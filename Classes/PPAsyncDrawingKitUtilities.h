//
//  PPAsyncDrawingKitUtilities.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@class PPTextRenderer;

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
} PPFontMetrics;

static inline CFRange CFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

static inline NSRange NSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline void hex16ToFloat(int hex) {
    int i = hex;
    float *f = (float *)&i;
    printf("%f\n",*f);
}

static inline _Nullable CGPathRef CreateCGPath(CGRect rect, CGFloat cornerRadius, UIRectCorner roundedCorners) {
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@interface NSObject (PPAsyncDrawingKit)
- (nullable id)pp_objectWithAssociatedKey:(void * _Nonnull)key;
- (void)pp_setObject:(id)object forAssociatedKey:( void *)key retained:(BOOL)retained;
- (void)pp_setObject:(id)object forAssociatedKey:( void *)key associationPolicy:(objc_AssociationPolicy)policy;
@end

@interface NSMutableDictionary (PPAsyncDrawingKit)
- (void)pp_setSafeObject:(nullable id)object forKey:(NSString *)key;
@end

@interface UIImage (PPAsyncDrawingKit)
- (CGRect)pp_convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;
- (void)pp_drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode withContext:(nullable CGContextRef)context;
@end

@interface NSAttributedString (PPAsyncDrawingKit)
+ (nullable PPTextRenderer *)rendererForCurrentThread;
+ (nullable PPTextRenderer *)pp_sharedTextRenderer;
- (nullable PPTextRenderer *)pp_sharedTextRenderer;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount baselineMetrics:(PPFontMetrics)baselineMetrics;
@end

@interface NSCoder (PPAsyncDrawingKit)
- (void)pp_encodeFontMetrics:(PPFontMetrics)fontMetrics forKey:(NSString *)key;
- (PPFontMetrics)pp_decodeFontMetricsForKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END

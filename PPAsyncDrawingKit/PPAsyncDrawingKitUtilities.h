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
#import <CoreText/CoreText.h>

@class PPTextRenderer;

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
} PPFontMetrics;

static inline CFRange PPCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

static inline NSRange PPNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline void hex16ToFloat(int hex) {
    int i = hex;
    float *f = (float *)&i;
    printf("%f\n",*f);
}

static inline __nullable CGPathRef CreateCGPath(CGRect rect, CGFloat cornerRadius, UIRectCorner roundedCorners) {
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@interface NSObject (PPAsyncDrawingKit)
- (nullable id)pp_objectWithAssociatedKey:(void * __nonnull)key;
- (void)pp_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retained;
- (void)pp_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy;
@end

@interface NSMutableDictionary (PPAsyncDrawingKit)
- (void)pp_setSafeObject:(id)object forKey:(NSString *)key;
@end

@interface NSCoder (PPAsyncDrawingKit)
- (void)pp_encodeFontMetrics:(PPFontMetrics)fontMetrics forKey:(NSString *)key;
- (PPFontMetrics)pp_decodeFontMetricsForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END

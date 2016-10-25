//
//  PPAsyncDrawingKitUtilities.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

static inline CGPathRef CreateCGPath(CGRect rect, CGFloat cornerRadius, UIRectCorner roundedCorners) {
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@interface NSMutableDictionary (Safe)
- (void)setSafeObject:(nullable id)object forKey:(nonnull NSString *)key;
@end

@interface UIImage (Util)
- (CGRect)pp_convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;
- (void)pp_drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode withContext:(CGContextRef)context;
@end

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

@interface NSMutableAttributedString (PPAsyncDrawingKit)
@property (nonatomic, strong) UIFont *pp_font;
@property (nonatomic, assign) CGFloat pp_lineHeight;
@property (nonatomic, assign) CGFloat pp_kerning;
@property (nonatomic, assign) NSTextAlignment pp_alignment;
+ (instancetype)stringWithString:(NSString *)string;
- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight;
- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)pp_setLineHeight:(CGFloat)lineHeight inRange:(NSRange)range;
- (void)pp_setCTFont:(CTFontRef)CTFont;
- (void)pp_setKerning:(CGFloat)kerning inRange:(NSRange)range;
- (void)pp_setBackgroundColor:(UIColor *)backgroundColor inRange:(NSRange)range;
- (void)pp_setColor:(UIColor *)color;
- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range;
- (void)pp_setCTFont:(CTFontRef)CTFont inRange:(NSRange)range;
- (void)pp_setFont:(UIFont *)font inRange:(NSRange)range;
- (NSRange)pp_effectiveRangeWithRange:(NSRange)range;
- (NSRange)pp_stringRange;
@end

@interface UIFont (PPAsyncDrawingKit)
+ (void)pp_createFontDescriptors;
+ (instancetype)pp_fontWithCTFont:(CTFontRef)CTFont;
+ (CTFontDescriptorRef)pp_newFontDescriptorForName:(NSString *)name;
+ (CTFontRef)pp_newCTFontWithName:(NSString *)name size:(CGFloat)size;
+ (CTFontRef)pp_newCTFontWithCTFont:(CTFontRef)CTFont symbolicTraits:(NSUInteger)symbolicTraits;
+ (CTFontRef)pp_newItalicCTFontForCTFont:(CTFontRef)CTFont;
+ (CTFontRef)pp_newBoldCTFontForCTFont:(CTFontRef)CTFont;
+ (CTFontRef)pp_newBoldSystemCTFontOfSize:(CGFloat)size;
+ (CTFontRef)pp_newSystemCTFontOfSize:(CGFloat)size;
@end

@interface NSCoder (PPAsyncDrawingKit)
- (void)pp_encodeFontMetrics:(PPFontMetrics)fontMetrics forKey:(NSString *)key;
- (PPFontMetrics)pp_decodeFontMetricsForKey:(NSString *)key;
@end

@interface NSString (PPAsyncDrawingKit)
- (void)enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString *capturedString, NSRange capturedRange, BOOL *stop))block;

@end
NS_ASSUME_NONNULL_END

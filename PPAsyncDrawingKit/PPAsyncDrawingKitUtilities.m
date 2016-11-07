//
//  PPAsyncDrawingKitUtilities.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingKitUtilities.h"
#import "PPTextRenderer.h"

@implementation NSObject (PPAsyncDrawingKit)
- (id)pp_objectWithAssociatedKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)pp_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retained
{
    objc_setAssociatedObject(self, key, object, retained ? OBJC_ASSOCIATION_RETAIN_NONATOMIC : OBJC_ASSOCIATION_ASSIGN);
}

- (void)pp_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, key, object, policy);
}
@end

@implementation NSMutableDictionary (PPAsyncDrawingKit)
- (void)pp_setSafeObject:(id)object forKey:(NSString *)key
{
    if (object) {
        [self setObject:object forKey:key];
    }
}
@end

@implementation UIImage (PPAsyncDrawingKit)
- (CGRect)pp_convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode
{
    CGSize size = self.size;
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (contentMode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (contentMode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}

- (void)pp_drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode withContext:(CGContextRef)context
{
    BOOL clip = NO;
    CGRect originalRect = rect;
    if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
        clip = contentMode != UIViewContentModeScaleAspectFill && contentMode != UIViewContentModeScaleAspectFit;
        rect = [self pp_convertRect:rect withContentMode:contentMode];
    }
    
    if (clip) {
        CGContextSaveGState(context);
        CGContextAddRect(context, originalRect);
        CGContextClip(context);
    }
    
    [self drawInRect:rect];
    
    if (clip) {
        CGContextRestoreGState(context);
    }
}
@end

@implementation NSAttributedString (PPAsyncDrawingKit)

+ (PPTextRenderer *)rendererForCurrentThread
{
    NSString *key = @"com.dskcpp.PPAsyncDrawingKit.thread-textrenderer";
    PPTextRenderer *textRenderer = [[NSThread currentThread] pp_objectWithAssociatedKey:&key];
    if (!textRenderer) {
        textRenderer = [[PPTextRenderer alloc] init];
        [[NSThread currentThread] pp_setObject:textRenderer forAssociatedKey:&key retained:YES];
    }
    return textRenderer;
}

+ (PPTextRenderer *)pp_sharedTextRenderer
{
    return [self rendererForCurrentThread];
}

- (PPTextRenderer *)pp_sharedTextRenderer
{
    return [[self class] pp_sharedTextRenderer];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size
{
    return [self pp_sizeConstrainedToSize:size numberOfLines:0];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines
{
    return [self pp_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:0];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount
{
    PPFontMetrics fontMetrics;
    return [self pp_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:derivedLineCount baselineMetrics:fontMetrics];
}

- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount baselineMetrics:(PPFontMetrics)baselineMetrics
{
    PPTextRenderer *textRenderer = [NSAttributedString pp_sharedTextRenderer];
    PPTextLayout *textLayout = textRenderer.textLayout;
    textLayout.attributedString = self;
    textLayout.size = size;
    textLayout.maximumNumberOfLines = numberOfLines;
    textLayout.baselineFontMetrics = baselineMetrics;
    CGSize resultSize;
    if (textLayout) {
        resultSize = textLayout.layoutSize;
    } else {
        resultSize = CGSizeZero;
    }
//    textLayout.containingLineCount
    return resultSize;
}

@end

@implementation NSMutableAttributedString (PPAsyncDrawingKit)
- (void)pp_setColor:(UIColor *)color
{
    [self pp_setColor:color inRange:[self pp_stringRange]];
}

- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (!color) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
    } else {
        // WBTextDefaultForegroundColorAttributeName
        [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:range];
    }
}

- (void)pp_setCTFont:(CTFontRef)CTFont
{
    [self pp_setCTFont:CTFont inRange:[self pp_stringRange]];
}

- (void)pp_setCTFont:(CTFontRef)CTFont inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (CTFont) {
        [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id _Nonnull)(CTFont) range:range];
    } else {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
    }
}

- (void)pp_setBackgroundColor:(UIColor *)backgroundColor inRange:(NSRange)range
{
    range = [self pp_effectiveRangeWithRange:range];
    if (backgroundColor) {
        [self addAttribute:@"PPTextBackgroundColorAttributeName" value:backgroundColor range:range];
    } else {
        [self removeAttribute:@"PPTextBackgroundColorAttributeName" range:range];
    }
}

- (NSRange)pp_stringRange
{
    return NSMakeRange(0, self.length);
}

- (NSRange)pp_effectiveRangeWithRange:(NSRange)range
{
    NSUInteger max = range.location + range.location;
    if (max > self.length) {
        return NSMakeRange(0, 0);
    } else if (max == self.length) {
        return range;
    }
    return range;
}
@end

@implementation NSCoder (PPAsyncDrawingKit)
- (void)pp_encodeFontMetrics:(PPFontMetrics)fontMetrics forKey:(nonnull NSString *)key
{
    [self encodeCGRect:CGRectMake(fontMetrics.ascent, fontMetrics.descent, fontMetrics.leading, 0) forKey:key];
}

- (PPFontMetrics)pp_decodeFontMetricsForKey:(NSString *)key
{
    CGRect rect = [self decodeCGRectForKey:key];
    PPFontMetrics fontMetrics;
    fontMetrics.ascent = rect.origin.x;
    fontMetrics.descent = rect.origin.y;
    fontMetrics.leading = rect.size.width;
    return fontMetrics;
}
@end

@implementation UIFont (PPAsyncDrawingKit)
static CTFontDescriptorRef arialMTFontDescriptor;
static CTFontDescriptorRef appleColorEmojiFontDescriptor;
static CTFontDescriptorRef zapfDingbatsITCFontDescriptor;
static CTFontDescriptorRef systemFontDescriptor;

+ (void)pp_createFontDescriptors
{
    if (arialMTFontDescriptor) {
        CFRelease(arialMTFontDescriptor);
        arialMTFontDescriptor = NULL;
    }
    if (appleColorEmojiFontDescriptor) {
        CFRelease(appleColorEmojiFontDescriptor);
        appleColorEmojiFontDescriptor = NULL;
    }
    if (zapfDingbatsITCFontDescriptor) {
        CFRelease(zapfDingbatsITCFontDescriptor);
        zapfDingbatsITCFontDescriptor = NULL;
    }
    if (systemFontDescriptor) {
        CFRelease(systemFontDescriptor);
        systemFontDescriptor = NULL;
    }
    NSDictionary *arialMTAttribtues = @{(NSString *)kCTFontNameAttribute : @"ArialMT"};
    arialMTFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)arialMTAttribtues);
    NSDictionary *appleColorEmojiAttribtues = @{(NSString *)kCTFontNameAttribute : @"AppleColorEmoji"};
    appleColorEmojiFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)appleColorEmojiAttribtues);
    NSMutableCharacterSet *set = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(0, 0)];
    NSDictionary *zapfDingbatsITCAttributes = @{(NSString *)kCTFontCharacterSetAttribute : set};
    zapfDingbatsITCFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)zapfDingbatsITCAttributes);
    NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    if (systemVersion >= 9) {
       systemFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)@{(NSString *)kCTFontNameAttribute : @"PingFangSC-Regular"});
    } else {
        systemFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)@{(NSString *)kCTFontNameAttribute : @"PingFangSC-Regular"});
    }
}

+ (instancetype)pp_fontWithCTFont:(CTFontRef)CTFont
{
    CFStringRef fontName = CTFontCopyName(CTFont, kCTFontPostScriptNameKey);
    return [UIFont fontWithName:(__bridge NSString *)fontName size:CTFontGetSize(CTFont)];
}

+ (CTFontDescriptorRef)pp_newFontDescriptorForName:(NSString *)name
{
    NSArray *fonts = @[(__bridge id)arialMTFontDescriptor,
                       (__bridge id)appleColorEmojiFontDescriptor,
                       (__bridge id)zapfDingbatsITCFontDescriptor,
                       (__bridge id)systemFontDescriptor];
    
    NSDictionary *attributes = @{(NSString *)kCTFontNameAttribute : name,
                                 (NSString *)kCTFontCascadeListAttribute : fonts};
    return CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
}

+ (CTFontRef)pp_newCTFontWithName:(NSString *)name size:(CGFloat)size
{
    @synchronized (self) {
        [self pp_createFontDescriptors];
    }
    return CTFontCreateWithFontDescriptor([self pp_newFontDescriptorForName:name], size, NULL);
}

//+ (CTFontRef)pp_newCTFontWithCTFont:(CTFontRef)CTFont symbolicTraits:(NSUInteger)symbolicTraits;
//+ (CTFontRef)pp_newItalicCTFontForCTFont:(CTFontRef)CTFont;
//+ (CTFontRef)pp_newBoldCTFontForCTFont:(CTFontRef)CTFont;
//+ (CTFontRef)pp_newBoldSystemCTFontOfSize:(CGFloat)size;
+ (CTFontRef)pp_newSystemCTFontOfSize:(CGFloat)size
{
    return CTFontCreateUIFontForLanguage(kCTFontUIFontSystem, size, NULL);
}
@end

@implementation NSString (PPAsyncDrawingKit)
- (void)enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString * _Nonnull, NSRange, BOOL * _Nonnull))block
{
    NSError *error;
    NSRegularExpression *httpRegex = [[NSRegularExpression alloc] initWithPattern:regex options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Regex Error: %@", error);
    }
    [httpRegex enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *subText = [self substringWithRange:result.range];
        block(subText, result.range, stop);
    }];
}
@end

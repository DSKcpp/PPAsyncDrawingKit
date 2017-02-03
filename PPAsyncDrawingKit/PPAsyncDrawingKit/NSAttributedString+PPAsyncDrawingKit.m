//
//  NSAttributedString+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "PPTextLayout.h"
#import "PPTextAttachment.h"
#import "NSThread+PPTextRenderer.h"

static void PPRunDelegateDeallocCallback(void *ref) { }

static CGFloat PPRunDelegateGetAscentCallback(void *ref) {
    PPTextAttachment *attachment = (__bridge PPTextAttachment *)(ref);
    if ([attachment isKindOfClass:[PPTextAttachment class]]) {
        CGFloat height = [attachment placeholderSize].height;
        return height;
    }
    return 0.0f;
}

static CGFloat PPRunDelegateGetWidthCallback(void *ref) {
    PPTextAttachment *attachment = (__bridge PPTextAttachment *)(ref);
    if ([attachment isKindOfClass:[PPTextAttachment class]]) {
        return [attachment placeholderSize].width;
    }
    return 0.0f;
}

static CGFloat PPRunDelegateGetDecentCallback(void *ref) {
    return 0.0f;
}

static CTLineBreakMode NSLineBreakModeToCTLineBreakMode(NSLineBreakMode nsLineBreakMode) {
    CTLineBreakMode lineBreak;
    switch (nsLineBreakMode) {
        case NSLineBreakByWordWrapping:
            lineBreak = kCTLineBreakByWordWrapping;
            break;
        case NSLineBreakByCharWrapping:
            lineBreak = kCTLineBreakByCharWrapping;
            break;
        case NSLineBreakByClipping:
            lineBreak = kCTLineBreakByClipping;
            break;
        case NSLineBreakByTruncatingHead:
            lineBreak = kCTLineBreakByTruncatingHead;
            break;
        case NSLineBreakByTruncatingTail:
            lineBreak = kCTLineBreakByTruncatingTail;
            break;
        case NSLineBreakByTruncatingMiddle:
            lineBreak = kCTLineBreakByTruncatingMiddle;
            break;
        default:
            break;
    }
    return lineBreak;
}

@implementation NSAttributedString (PPAsyncDrawingKit)


- (NSRange)pp_stringRange
{
    return NSMakeRange(0, self.length);
}

+ (PPTextLayout *)textLayoutForCurrentThread
{
    return [NSThread currentThread].textLayout;
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width
{
    return [self pp_heightConstrainedToWidth:width exclusionPaths:nil];
}

- (CGFloat)pp_heightConstrainedToWidth:(CGFloat)width exclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    PPTextLayout *textLayout = [NSAttributedString textLayoutForCurrentThread];
    textLayout.numberOfLines = 0;
    textLayout.attributedString = self;
    textLayout.exclusionPaths = exclusionPaths;
    textLayout.maxSize = CGSizeMake(width, 20000);
    return textLayout.layoutHeight;
}

- (CGSize)pp_sizeConstrainedToWidth:(CGFloat)width
{
    return [self pp_sizeConstrainedToSize:CGSizeMake(width, 20000)];
}

- (CGSize)pp_sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines
{
    return [self pp_sizeConstrainedToSize:CGSizeMake(width, 20000) numberOfLines:numberOfLines];
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
    PPTextLayout *textLayout = [NSAttributedString textLayoutForCurrentThread];
    textLayout.attributedString = self;
    textLayout.maxSize = size;
    textLayout.numberOfLines = numberOfLines;
    CGSize resultSize;
    if (textLayout) {
        resultSize = textLayout.layoutSize;
    } else {
        resultSize = CGSizeZero;
    }
    //    textLayout.containingLineCount
    return resultSize;
}

+ (instancetype)pp_attributedStringWithTextAttachment:(PPTextAttachment *)textAttachment
{
    return [self pp_attributedStringWithTextAttachment:textAttachment attributes:nil];
}

+ (instancetype)pp_attributedStringWithTextAttachment:(PPTextAttachment *)textAttachment attributes:(NSDictionary *)attributes
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = PPRunDelegateDeallocCallback;
    callbacks.getAscent = PPRunDelegateGetAscentCallback;
    callbacks.getDescent = PPRunDelegateGetDecentCallback;
    callbacks.getWidth = PPRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(textAttachment));
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    attr[PPTextAttachmentAttributeName] = textAttachment;
    attr[(NSString *)kCTForegroundColorAttributeName] = (__bridge id _Nullable)([UIColor clearColor].CGColor);
    attr[(NSString *)kCTRunDelegateAttributeName] = (__bridge id)runDelegate;
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    CFRelease(runDelegate);
    return [[NSAttributedString alloc] initWithString:content attributes:attr];
}

- (CGSize)pp_drawInRect:(CGRect)rect
{
    return [self pp_drawInRect:rect context:UIGraphicsGetCurrentContext()];
}

- (CGSize)pp_drawInRect:(CGRect)rect context:(CGContextRef)context
{
    return [self pp_drawInRect:rect context:context numberOfLines:0];
}

- (CGSize)pp_drawInRect:(CGRect)rect context:(CGContextRef)context numberOfLines:(NSUInteger)numberOfLines
{
    PPTextLayout *textLayout = [NSAttributedString textLayoutForCurrentThread];
    textLayout.numberOfLines = numberOfLines;
    textLayout.attributedString = self;
    textLayout.frame = rect;
    [textLayout.textRenderer drawInContext:context];
    return textLayout.layoutSize;
}

@end

@implementation NSMutableAttributedString (PPExtendedAttributedString)
- (NSRange)pp_effectiveRangeWithRange:(NSRange)range
{
    NSUInteger max = range.location + range.length;
    if (max > self.length) {
        return NSMakeRange(range.location, range.length);
    }
    return range;
}

- (void)pp_setAttribute:(NSString *)name value:(id)value {
    [self pp_setAttribute:name value:value range:self.pp_stringRange];
}

- (void)pp_setAttribute:(NSString *)name value:(id)value range:(NSRange)range
{
    if (!name) {
        return ;
    }
    range = [self pp_effectiveRangeWithRange:range];
    if (value) {
        [self addAttribute:name value:value range:range];
    } else {
        [self removeAttribute:name range:range];
    }
}

- (void)pp_setKerning:(CGFloat)kerning
{
    [self pp_setKerning:kerning inRange:self.pp_stringRange];
}

- (void)pp_setKerning:(CGFloat)kerning inRange:(NSRange)range
{
    CFNumberRef number = CFNumberCreate(kCFAllocatorDefault,kCFNumberCGFloatType,&kerning);
    [self pp_setAttribute:(id)kCTKernAttributeName value:(__bridge id _Nullable)(number) range:range];
    CFRelease(number);
}

- (void)pp_setColor:(UIColor *)color
{
    [self pp_setColor:color inRange:[self pp_stringRange]];
}

- (void)pp_setColor:(UIColor *)color inRange:(NSRange)range
{
    [self pp_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

- (void)pp_setFont:(UIFont *)font
{
    [self pp_setFont:font inRange:[self pp_stringRange]];
}

- (void)pp_setFont:(UIFont *)font inRange:(NSRange)range
{
    [self pp_setAttribute:NSFontAttributeName value:font range:range];
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

- (void)pp_setTextHighlightRange:(PPTextHighlightRange *)textHighlightRange
{
    [self pp_setTextHighlightRange:textHighlightRange inRange:[self pp_stringRange]];
}

- (void)pp_setTextHighlightRange:(PPTextHighlightRange *)textHighlightRange inRange:(NSRange)range
{
    [self pp_setAttribute:PPTextHighlightRangeAttributeName value:textHighlightRange range:range];
}

- (void)pp_setTextParagraphStyle:(NSParagraphStyle *)textParagraphStyle
{
    [self pp_setTextParagraphStyle:textParagraphStyle inRange:[self pp_stringRange]];
}

- (void)pp_setTextParagraphStyle:(NSParagraphStyle *)textParagraphStyle inRange:(NSRange)range
{
    [self pp_setAttribute:NSParagraphStyleAttributeName value:textParagraphStyle range:range];
}

- (void)pp_setAlignment:(NSTextAlignment)alignment
{
    [self pp_setAlignment:alignment lineBreakMode:NSLineBreakByWordWrapping lineHeight:0.0f];
}

- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self pp_setAlignment:alignment lineBreakMode:lineBreakMode lineHeight:0.0f];
}

- (void)pp_setAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight
{
    CTParagraphStyleSetting aligmentStyle;
    CTTextAlignment aligment = NSTextAlignmentToCTTextAlignment(alignment);
    aligmentStyle.value = &aligment;
    aligmentStyle.valueSize = sizeof(CTTextAlignment);
    aligmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    CTParagraphStyleSetting lineBreakModelStyle;
    CTLineBreakMode lineBreak = NSLineBreakModeToCTLineBreakMode(lineBreakMode);
    lineBreakModelStyle.value = &lineBreak;
    lineBreakModelStyle.valueSize = sizeof(CTLineBreakMode);
    lineBreakModelStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    
    CTParagraphStyleSetting settings[2] = {aligmentStyle, lineBreakModelStyle};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
    [self pp_setAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:self.pp_stringRange];
    CFRelease(paragraphStyle);
}

- (void)pp_setLineHeight:(CGFloat)lineHeight
{
    [self pp_setLineHeight:lineHeight inRange:self.pp_stringRange];
}

- (void)pp_setLineHeight:(CGFloat)lineHeight inRange:(NSRange)range
{
    CTParagraphStyleSetting minimumLineHeight;
    minimumLineHeight.value = &lineHeight;
    minimumLineHeight.valueSize = sizeof(CGFloat);
    minimumLineHeight.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    
    CTParagraphStyleSetting settings[1] = {minimumLineHeight};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
    [self pp_setAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:range];
    CFRelease(paragraphStyle);
}

- (void)pp_setCTRunDelegate:(CTRunDelegateRef)ctRunDelegate
{
    [self pp_setCTRunDelegate:ctRunDelegate inRange:self.pp_stringRange];
}

- (void)pp_setCTRunDelegate:(CTRunDelegateRef)ctRunDelegate inRange:(NSRange)range
{
    [self pp_setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id _Nullable)(ctRunDelegate) range:range];
}
@end

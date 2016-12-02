//
//  PPTextParagraphStyle.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextParagraphStyle.h"

@implementation PPTextParagraphStyle
{
    struct {
        unsigned int didUpdateAttribute:1;
    } delegateHas;
}

+ (PPTextParagraphStyle *)defaultParagraphStyle
{
    PPTextParagraphStyle *instance = [[PPTextParagraphStyle alloc] init];
    instance.lineSpacing = 5.0f;
    instance.allowsDynamicLineSpacing = YES;
    instance.lineBreakMode = NSLineBreakByWordWrapping;
    instance.alignment = NSTextAlignmentLeft;
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (CTParagraphStyleRef)newCTParagraphStyleWithFontSize:(CGFloat)fontSize
{
    CGFloat paragraphSpacingBefore = self.paragraphSpacingBefore;
    CGFloat paragraphSpacingAfter = self.paragraphSpacingAfter;
    
    CTParagraphStyleSetting aligmentStyle;
    CTTextAlignment aligment = NSTextAlignmentToCTTextAlignment(self.alignment);
    aligmentStyle.value = &aligment;
    aligmentStyle.valueSize = sizeof(CTTextAlignment);
    aligmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    CTParagraphStyleSetting lineBreakModel;
    CTLineBreakMode lineBreak = self.lineBreakMode;
    lineBreakModel.value = &lineBreak;
    lineBreakModel.valueSize = sizeof(CTLineBreakMode);
    lineBreakModel.spec = kCTParagraphStyleSpecifierLineBreakMode;
    
    CTParagraphStyleSetting maximumLineHeight;
    CGFloat maxHeight = self.maximumLineHeight > 0 ? self.maximumLineHeight : fontSize + self.lineSpacing;
    maximumLineHeight.value = &maxHeight;
    maximumLineHeight.valueSize = sizeof(CGFloat);
    maximumLineHeight.spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    
    CTParagraphStyleSetting minimumLineHeight;
    minimumLineHeight.value = &maxHeight;
    minimumLineHeight.valueSize = sizeof(CGFloat);
    minimumLineHeight.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    
    CTParagraphStyleSetting maximumLineSpacingStyle;
    CGFloat maximumLineSpacing = 1;
    maximumLineSpacingStyle.value = &maximumLineSpacing;
    maximumLineSpacingStyle.valueSize = sizeof(CGFloat);
    maximumLineSpacingStyle.spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    
    CTParagraphStyleSetting minimumLineSpacingStyle;
    CGFloat minimumLineSpacing = 1;
    minimumLineSpacingStyle.value = &minimumLineSpacing;
    minimumLineSpacingStyle.valueSize = sizeof(CGFloat);
    minimumLineSpacingStyle.spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    
    
    CTParagraphStyleSetting writedicStyle;
    CTWritingDirection writedic = kCTWritingDirectionLeftToRight;
    writedicStyle.value = &writedic;
    writedicStyle.valueSize = sizeof(CTWritingDirection);
    writedicStyle.spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    
    CTParagraphStyleSetting settings[] = {lineBreakModel, maximumLineHeight, minimumLineHeight, maximumLineSpacingStyle, minimumLineSpacingStyle, aligmentStyle, writedicStyle};
    [self propertyUpdated];
    return CTParagraphStyleCreate(settings, 7);
}

- (NSMutableParagraphStyle *)nsParagraphStyleWithFontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.alignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    paragraphStyle.minimumLineHeight = fontSize;
    paragraphStyle.maximumLineHeight = fontSize;
    paragraphStyle.lineSpacing = self.lineSpacing;
    if (_isNeedChangeSpace == NO) {
        
    }
    paragraphStyle.paragraphSpacingBefore = self.paragraphSpacingBefore;
    paragraphStyle.paragraphSpacing = self.paragraphSpacingAfter;
    return paragraphStyle;
}

- (void)setDelegate:(id<PPTextParagraphStyleDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        delegateHas.didUpdateAttribute = [delegate respondsToSelector:@selector(pp_paragraphStyleDidUpdateAttribute:)];
    }
}

- (void)setAllowsDynamicLineSpacing:(BOOL)allowsDynamicLineSpacing
{
    if (_allowsDynamicLineSpacing == allowsDynamicLineSpacing) {
        return;
    }
    _allowsDynamicLineSpacing = allowsDynamicLineSpacing;
    [self propertyUpdated];
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    if (_alignment == alignment) {
        return;
    }
    _alignment = alignment;
    [self propertyUpdated];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (_lineBreakMode == lineBreakMode) {
        return;
    }
    _lineBreakMode = lineBreakMode;
    [self propertyUpdated];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing == lineSpacing) {
        return;
    }
    _lineSpacing = lineSpacing;
    [self propertyUpdated];
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight
{
    if (_maximumLineHeight == maximumLineHeight) {
        return;
    }
    _maximumLineHeight = maximumLineHeight;
    [self propertyUpdated];
}

- (void)setParagraphSpacingAfter:(CGFloat)paragraphSpacingAfter
{
    if (_paragraphSpacingAfter == paragraphSpacingAfter) {
        return;
    }
    _paragraphSpacingAfter = paragraphSpacingAfter;
    [self propertyUpdated];
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore
{
    if (_paragraphSpacingBefore == paragraphSpacingBefore) {
        return;
    }
    _paragraphSpacingBefore = paragraphSpacingBefore;
    [self propertyUpdated];
}

- (void)propertyUpdated
{
    if (delegateHas.didUpdateAttribute != 0) {
        [_delegate pp_paragraphStyleDidUpdateAttribute:self];
    }
}
@end

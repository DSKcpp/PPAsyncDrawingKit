//
//  PPTextAttributes.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/10.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextAttributes.h"
#import <CoreText/CoreText.h>

NSString * const PPTextHighlightRangeAttributeName = @"PPTextHighlightRangeAttributeName";
NSString * const PPTextBorderAttributeName         = @"PPTextBorderAttributeName";
NSString * const PPTextAttachmentAttributeName     = @"PPTextAttachmentAttributeName";

@implementation PPTextHighlightRange
- (void)_setAttribute:(NSString *)name value:(id)value
{
    if (value) {
        self.attributes[name] = value;
    } else {
        [self.attributes removeObjectForKey:name];
    }
}
- (void)setTextColor:(UIColor *)textColor
{
    [self _setAttribute:(id)kCTForegroundColorAttributeName value:(id)textColor.CGColor];
}

- (void)setFont:(UIFont *)font
{
    [self _setAttribute:NSFontAttributeName value:font];
}

- (void)setBorder:(PPTextBorder *)border
{
    [self _setAttribute:PPTextBorderAttributeName value:border];
}

- (NSDictionary<NSString *,id> *)attributes
{
    if (!_attributes) {
        _attributes = @{}.mutableCopy;
    }
    return _attributes;
}

@end

@implementation PPTextBorder
- (instancetype)init
{
    if (self = [super init]) {
        _cornerRadius = 4.0f;
    }
    return self;
}
@end

@implementation PPTextBackground

@end

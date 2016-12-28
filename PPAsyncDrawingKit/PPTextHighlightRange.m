//
//  PPTextHighlightRange.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/6.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextHighlightRange.h"
#import <CoreText/CoreText.h>

NSString * const PPTextHighlightRangeAttributeName = @"PPTextHighlightRange";
NSString * const PPTextBorderAttributeName = @"PPTextBorder";
NSString * const PPTextAttachmentAttributeName = @"PPTextAttachment";

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

@end

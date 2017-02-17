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

//
//  PPTextAttachment.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextAttachment.h"

@implementation PPTextAttachment

+ (instancetype)attachmentWithContents:(id)contents contentType:(UIViewContentMode)contentType contentSize:(CGSize)contentSize
{
    PPTextAttachment *textAttachment = [[self alloc] init];
    textAttachment.contents = contents;
    textAttachment.contentType = contentType;
    textAttachment.contentSize = contentSize;
    return textAttachment;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (CGFloat)ascentForLayout
{
    CGSize placeholderSize = self.placeholderSize;
    return placeholderSize.height - self.baselineFontMetrics.descent;
}

- (CGFloat)descentForLayout
{
    return self.baselineFontMetrics.descent;
}

- (CGFloat)leadingForLayout
{
    return self.baselineFontMetrics.leading;
}

- (CGSize)placeholderSize
{
    CGSize size = self.contentSize;
    UIEdgeInsets edgeInsets = self.contentEdgeInsets;
    size.width += edgeInsets.left + edgeInsets.right;
    size.height += edgeInsets.top + edgeInsets.bottom;
    return size;
}
@end


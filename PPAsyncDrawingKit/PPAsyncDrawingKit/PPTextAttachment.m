//
//  PPTextAttachment.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextAttachment.h"

@implementation PPTextAttachment

+ (instancetype)attachmentWithContents:(id)contents type:(UIViewContentMode)type contentSize:(CGSize)contentSize
{
    PPTextAttachment *textAttachment = [[self alloc] init];
    textAttachment.contents = contents;
    textAttachment.contentType = type;
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        self.contentSize = [aDecoder decodeCGSizeForKey:@"contentSize"];
        self.contents = [aDecoder decodeObjectForKey:@"contents"];
        self.replacementText = [aDecoder decodeObjectForKey:@"contentDescription"];
        self.contentType = [aDecoder decodeIntegerForKey:@"contentType"];
        self.baselineFontMetrics = [aDecoder decodeObjectForKey:@"fontMetrics"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGSize:self.contentSize forKey:@"contentSize"];
    [aCoder encodeCGSize:self.placeholderSize forKey:@"placeholderSize"];
    if ([self.contents conformsToProtocol:@protocol(NSCoding)]) {
        [aCoder encodeObject:self.contents forKey:@"contents"];
    }
    [aCoder encodeObject:self.replacementText forKey:@"contentDescription"];
    [aCoder encodeInteger:self.contentType forKey:@"contentType"];
    [aCoder encodeObject:self.baselineFontMetrics forKey:@"fontMetrics"];
}

- (void)updateContentEdgeInsetsWithTargetPlaceholderSize:(CGSize)placeholderSize
{
    self.contentSize = placeholderSize;
}

- (PPTextFontMetrics *)fontMetricsForLayout
{
    PPTextFontMetrics *fontMetrisc = [[PPTextFontMetrics alloc] init];
    fontMetrisc.ascent = self.ascentForLayout;
    fontMetrisc.descent = self.descentForLayout;
    fontMetrisc.leading = self.leadingForLayout;
    return fontMetrisc;
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


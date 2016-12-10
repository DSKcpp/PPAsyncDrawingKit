//
//  WBTimelineLargeCardView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineLargeCardView.h"

@implementation WBTimelineLargeCardView

+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    return [[pageInfo timelineModelViewClass] sizeConstraintToWidth:width forPageInfo:pageInfo displayType:type];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

@end

@implementation WBPageInfoBaseCardView
+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    CGFloat height = [[self class] heightConstraintToWidth:width forPageInfo:pageInfo displayType:type];
    return CGSizeMake(width, height);
}

+ (CGFloat)heightConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    return 64.0f;
}

@end

@implementation WBTimelineLargeCardTextView
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    WBTimelinePageInfo *pageInfo = _pageInfo;
    _titleRenderer.frame = CGRectZero;
    [_titleRenderer drawInContext:context];
    _descRenderer.frame = CGRectZero;
    [_descRenderer drawInContext:context];
    return YES;
}
@end

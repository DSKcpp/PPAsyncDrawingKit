//
//  WBTimelineTableViewCellDrawingContext.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCellDrawingContext.h"

@implementation WBTimelineTableViewCellDrawingContext
- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)resetWithContentWidth:(CGFloat)width
{
    [self resetWithContentWidth:width userInfo:nil];
}

- (void)resetWithContentWidth:(CGFloat)width userInfo:(NSDictionary *)userInfo
{
    _contentWidth = width;
}

- (void)resetTimelineItem:(WBTimelineItem *)timelineItem
{
//    self.timelineItem
}
@end

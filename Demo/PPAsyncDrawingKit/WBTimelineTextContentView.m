//
//  WBTimelineTextContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTextContentView.h"
#import "WBTimelineTableViewCellDrawingContext.h"

@implementation WBTimelineTextContentView

+ (void)renderDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext userInfo:(NSDictionary *)userInfo
{
    drawingContext.contentHeight = 100;
}

@end

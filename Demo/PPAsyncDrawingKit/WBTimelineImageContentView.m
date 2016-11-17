//
//  WBTimelineImageContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineImageContentView.h"

@implementation WBTimelineImageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (NSMutableArray *)imageViews
{
    if (_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

@end

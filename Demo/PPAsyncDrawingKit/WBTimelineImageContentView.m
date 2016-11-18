//
//  WBTimelineImageContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineImageContentView.h"
#import "WBTimelineImageView.h"

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

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    if (_timelineItem != timelineItem) {
        _timelineItem = timelineItem;
        [self.imageViews enumerateObjectsUsingBlock:^(WBTimelineImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            imageView.timelineItem = timelineItem;
        }];
    }
}

- (void)setPictures:(NSArray<WBTimelinePicture *> *)pictures
{
    if (![_pictures isEqualToArray:pictures]) {
        _pictures = [pictures copy];
    }
}
@end

//
//  WBTimelineImageContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineImageContentView.h"
#import "WBTimelineImageView.h"
#import "WBTimelineItem.h"
#import "PPImageView+WebCache.h"
#import "WBTimelinePreset.h"

@implementation WBTimelineImageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (WBTimelineImageView *)dequeueReusableImageView
{
    WBTimelineImageView *imageView = self.idleContentImageViewAry.firstObject;
    if (imageView) {
        [self.idleContentImageViewAry removeObjectAtIndex:0];
    } else {
        imageView = [[WBTimelineImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = YES;
        [imageView addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
        imageView.enableAsyncDrawing = self.enableAsyncDrawing;
        [self.contentImageViewAry addObject:imageView];
    }
    return imageView;
}

- (void)imageSelected:(WBTimelineImageView *)imageView
{
    NSLog(@"%@", imageView);
}

- (NSMutableArray<WBTimelineImageView *> *)contentImageViewAry
{
    if (!_contentImageViewAry) {
        _contentImageViewAry = [NSMutableArray array];
    }
    return _contentImageViewAry;
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
        [self reloadImageViews];
    }
}

- (void)reloadImageViews
{
    [self.imageViews removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    NSUInteger count = _pictures.count;
    NSUInteger cols = 3;
    for (NSInteger i = 0; i < count; i++) {
        WBTimelineImageView *imageView = [self dequeueReusableImageView];
        if (count == 1) {
            imageView.frame = CGRectMake(0, 0, preset.verticalImageWidth, preset.verticalImageHeight);
        } else {
            NSUInteger row = i / cols;
            NSUInteger col = i % cols;
            imageView.frame = CGRectMake(col * (preset.gridImageSize + 2.5), row * (preset.gridImageSize + 2.5), preset.gridImageSize, preset.gridImageSize);
        }
        NSString *url = _pictures[i].bmiddle.url;
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar"]];
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
}

@end

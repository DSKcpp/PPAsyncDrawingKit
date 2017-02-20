//
//  WBTimelineImageContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineImageContentView.h"
#import "WBHelper.h"
#import "PPImageView+SDWebImage.h"

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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        [imageView addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return imageView;
}

- (void)imageSelected:(WBTimelineImageView *)imageView
{
    NSLog(@"%@", imageView);
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
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
    for (WBTimelineImageView *imageView in self.imageViews) {
        imageView.hidden = YES;
        [self addToIdleContentImageViewAry:imageView];
    }
    
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    NSMutableArray<WBTimelineImageView *> *imageViews = @[].mutableCopy;
    NSUInteger count = _pictures.count;
    NSUInteger cols = 3;
    
    __weak typeof(self) weakSelf = self;
    [_pictures enumerateObjectsUsingBlock:^(WBTimelinePicture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WBTimelineImageView *imageView = [weakSelf dequeueReusableImageView];
        if (count == 1) {
            imageView.frame = CGRectMake(0, 0, preset.verticalImageWidth, preset.verticalImageHeight);
        } else {
            NSUInteger row = idx / cols;
            NSUInteger col = idx % cols;
            imageView.frame = CGRectMake(col * (preset.gridImageSize + 2.5), row * (preset.gridImageSize + 2.5), preset.gridImageSize, preset.gridImageSize);
        }
        NSString *url = obj.bmiddle.url;
        [imageView setImageURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar"]];
        imageView.hidden = NO;
        [weakSelf addSubview:imageView];
        [imageViews addObject:imageView];
    }];
    [self.imageViews removeAllObjects];
    [self.imageViews addObjectsFromArray:imageViews];
}

- (void)addToIdleContentImageViewAry:(WBTimelineImageView *)imageView
{
    if (!_idleContentImageViewAry) {
        _idleContentImageViewAry = @[].mutableCopy;
    }
    [_idleContentImageViewAry addObject:imageView];
}
@end

@implementation WBTimelineImageView

@end


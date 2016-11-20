//
//  WBTimelineActionButtonsView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineActionButtonsView.h"
#import "PPButton.h"
#import "WBTimelinePreset.h"
#import "WBTimelineItem.h"

@implementation WBTimelineActionButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initActionButtons];
    }
    return self;
}

- (void)initActionButtons
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3.0f;
    CGFloat height = [WBTimelinePreset sharedInstance].actionButtonsHeight;
    
    _retweetButton = [[PPButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:_retweetButton];
    _commentButton = [[PPButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [self addSubview:_commentButton];
    _likeButton = [[PPButton alloc] initWithFrame:CGRectMake(width * 2.0f, 0, width, height)];
    [self addSubview:_likeButton];
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    NSString *retweetCount = [NSString stringWithFormat:@"%zd", timelineItem.reposts_count];
    [_retweetButton setTitle:retweetCount forState:UIControlStateNormal];
    NSString *commentCount = [NSString stringWithFormat:@"%zd", timelineItem.comments_count];
    [_commentButton setTitle:commentCount forState:UIControlStateNormal];
    NSString *likeCount = [NSString stringWithFormat:@"%zd", timelineItem.attitudes_count];
    [_likeButton setTitle:likeCount forState:UIControlStateNormal];
}

@end

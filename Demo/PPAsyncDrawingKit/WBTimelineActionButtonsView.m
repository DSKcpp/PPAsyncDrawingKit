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
#import "UIView+Frame.h"

@interface WBTimelineActionButtonsView ()
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation WBTimelineActionButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initActionButtons];
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)initActionButtons
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3.0f;
    CGFloat height = [WBTimelinePreset sharedInstance].actionButtonsHeight;
    
    _retweetButton = [[PPButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_retweetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_retweetButton setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
    _retweetButton.buttonInfo.titleFont = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_retweetButton];
    _commentButton = [[PPButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [_commentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_retweetButton setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
    _commentButton.buttonInfo.titleFont = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_commentButton];
    _likeButton = [[PPButton alloc] initWithFrame:CGRectMake(width * 2.0f, 0, width, height)];
    [_likeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
    _likeButton.buttonInfo.titleFont = [UIFont systemFontOfSize:12.0f];
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.bottomLine.frame = CGRectMake(0, frame.size.height - 0.5f, self.width, 0.5f);
}

@end

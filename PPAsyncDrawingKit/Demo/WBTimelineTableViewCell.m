//
//  WBTimelineTableViewCell.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCell.h"
#import "WBTimelineContentView.h"

@implementation WBTimelineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        _timelineContentView = [[WBTimelineContentView alloc] initWithWidth:width];
        _timelineContentView.cell = self;
        [self.contentView addSubview:_timelineContentView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (!self.isSelected) {
        [self setSelectionColor:self.isHighlighted];
    }
}

- (void)setSelectionColor:(BOOL)highlighted
{
    [_timelineContentView setSelectionColor:highlighted];
}

- (WBTimelineItem *)timelineItem
{
    return self.timelineContentView.timelineItem;
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    self.timelineContentView.timelineItem = timelineItem;
}

- (id<WBTimelineTableViewCellDelegate>)delegate
{
    return self.timelineContentView.delegate;
}

- (void)setDelegate:(id<WBTimelineTableViewCellDelegate>)delegate
{
    self.timelineContentView.delegate = delegate;
}

@end

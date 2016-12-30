//
//  WBTimelineTableViewCell.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCell.h"
#import "WBTimelineTextContentView.h"

@implementation WBTimelineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.timelineContentView = [[WBTimelineContentView alloc] initWithWidth:width];
        [self.contentView addSubview:self.timelineContentView];
    }
    return self;
}

- (WBTimelineItem *)timelineItem
{
    return self.timelineContentView.timelineItem;
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    self.timelineContentView.timelineItem = timelineItem;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
//    [self.timelineContentView.textContentView setNeedsDisplay];
}

@end

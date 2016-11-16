//
//  WBTimelineTableViewCell.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCell.h"
#import "WBTimelineContentView.h"
#import "WBTimelineTextContentView.h"

@implementation WBTimelineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timelineContentView = [[WBTimelineContentView alloc] initWithWidth:350.0f];
        [self.contentView addSubview:self.timelineContentView];
    }
    return self;
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    [self.timelineContentView setTimelineItem:timelineItem];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
//    [self.timelineContentView.textContentView setNeedsDisplay];
}

@end

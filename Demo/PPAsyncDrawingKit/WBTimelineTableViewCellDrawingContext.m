//
//  WBTimelineTableViewCellDrawingContext.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCellDrawingContext.h"
#import "PPAttributedText.h"
#import "WBTimelineItem.h"

@implementation WBTimelineTableViewCellDrawingContext
- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem
{
    if (self = [super init]) {
        self.itemAttributedText = [PPAttributedText new];
        self.itemAttributedText.shouldShowSmallCardForcily = YES;
        self.quotedItemAttributedText = [PPAttributedText new];
        self.quotedItemAttributedText.shouldShowSmallCardForcily = YES;
        self.titleItemAttributedText = [PPAttributedText new];
        self.titleItemAttributedText.shouldShowSmallCardForcily = YES;
        self.userInfo = [NSMutableDictionary dictionary];
        [self resetTimelineItem:timelineItem];
    }
    return self;
}

- (void)resetWithContentWidth:(CGFloat)width
{
    [self resetWithContentWidth:width userInfo:nil];
}

- (void)resetWithContentWidth:(CGFloat)width userInfo:(NSDictionary *)userInfo
{
    _contentWidth = width;
}

- (void)resetTimelineItem:(WBTimelineItem *)timelineItem
{
    if (self.timelineItem != timelineItem) {
        self.timelineItem = timelineItem;
        NSString *itemText = timelineItem.text;
        if (itemText) {
            self.itemAttributedText.attributedString = [[NSMutableAttributedString alloc] initWithString:itemText];
            _briefItemText = itemText;
        }
        NSString *userName = timelineItem.user.screen_name;
        if (userName) {
            _displayName = userName;
        }
        NSString *quotedItemText = timelineItem.retweeted_status.text;
        if (quotedItemText) {
            self.quotedItemAttributedText.attributedString = [[NSMutableAttributedString alloc] initWithString:quotedItemText];
            _briefQuotedItemText = timelineItem.retweeted_status.text;
        }
    }
}
@end

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
        self.titleAttributedText = [PPAttributedText new];
        self.titleAttributedText.shouldShowSmallCardForcily = YES;
        self.metaInfoAttributedText = [PPAttributedText new];
        self.metaInfoAttributedText.shouldShowSmallCardForcily = YES;
        self.textAttributedText = [PPAttributedText new];
        self.textAttributedText.shouldShowSmallCardForcily = YES;
        self.quotedAttributedText = [PPAttributedText new];
        self.quotedAttributedText.shouldShowSmallCardForcily = YES;
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
            self.textAttributedText.attributedString = [[NSMutableAttributedString alloc] initWithString:itemText];
        }
        if (timelineItem.retweeted_status) {
            NSString *quotedItemText = [NSString stringWithFormat:@"@%@:%@", timelineItem.retweeted_status.user.screen_name, timelineItem.retweeted_status.text] ;
            if (quotedItemText.length > 0) {
                self.quotedAttributedText.attributedString = [[NSMutableAttributedString alloc] initWithString:quotedItemText];
            }
        }
        if (timelineItem.title) {
            NSString *title = timelineItem.title.text;
            self.titleAttributedText.attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        }
    }
}

- (BOOL)hasQuoted
{
    return self.timelineItem.retweeted_status != nil;
}

- (BOOL)hasPhoto
{
    return self.timelineItem.pic_infos.count > 0 || self.timelineItem.retweeted_status.pic_infos.count > 0;
}

- (BOOL)hasTitle
{
    return self.timelineItem.title != nil;
}
@end

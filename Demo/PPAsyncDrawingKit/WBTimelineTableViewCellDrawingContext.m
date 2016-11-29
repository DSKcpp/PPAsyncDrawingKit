//
//  WBTimelineTableViewCellDrawingContext.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineTableViewCellDrawingContext.h"
#import "PPTextAttributed.h"
#import "WBTimelineItem.h"
#import "WBTimelineAttributedTextParser.h"
#import "WBTimelinePreset.h"

@implementation WBTimelineTableViewCellDrawingContext
- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem
{
    if (self = [super init]) {
        _timelineItem = timelineItem;
        self.titleAttributedText = [PPTextAttributed new];
        self.titleAttributedText.shouldShowSmallCardForcily = YES;
        self.metaInfoAttributedText = [PPTextAttributed new];
        self.metaInfoAttributedText.shouldShowSmallCardForcily = YES;
        self.textAttributedText = [PPTextAttributed new];
        self.textAttributedText.shouldShowSmallCardForcily = YES;
        self.quotedAttributedText = [PPTextAttributed new];
        self.quotedAttributedText.shouldShowSmallCardForcily = YES;
        NSString *itemText = timelineItem.text;
        if (itemText) {
            self.textAttributedText.textParser = [[WBTimelineAttributedTextParser alloc] init];
            [self.textAttributedText resetTextStorageWithPlainText:itemText];
        }
        if (timelineItem.retweeted_status) {
            NSString *quotedItemText = [NSString stringWithFormat:@"@%@:%@", timelineItem.retweeted_status.user.screen_name, timelineItem.retweeted_status.text] ;
            if (quotedItemText.length > 0) {
                self.quotedAttributedText.textParser = [[WBTimelineAttributedTextParser alloc] init];
                [self.quotedAttributedText resetTextStorageWithPlainText:quotedItemText];
            }
        }
        if (timelineItem.title) {
            NSString *title = timelineItem.title.text;
            self.titleAttributedText.fontSize = [WBTimelinePreset sharedInstance].titleFontSize;
            self.titleAttributedText.textParser = [[WBTimelineAttributedTextParser alloc] init];
            [self.titleAttributedText resetTextStorageWithPlainText:title];
        }
    }
    return self;
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

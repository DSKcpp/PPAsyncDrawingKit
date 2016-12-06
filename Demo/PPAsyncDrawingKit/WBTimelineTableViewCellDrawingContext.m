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
#import "NSAttributedString+PPAsyncDrawingKit.h"

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
            self.textAttributedText.paragraphStyle = [PPTextParagraphStyle defaultParagraphStyle];
            self.textAttributedText.textParser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
            [self.textAttributedText resetTextStorageWithPlainText:itemText];
            self.textAttributedText.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
        }
        if (timelineItem.retweeted_status) {
            NSString *quotedItemText;
            if (timelineItem.retweeted_status.user.screen_name) {
                quotedItemText = [NSString stringWithFormat:@"@%@:%@", timelineItem.retweeted_status.user.screen_name, timelineItem.retweeted_status.text];
            } else {
                quotedItemText = timelineItem.retweeted_status.text;
            }
            if (quotedItemText.length > 0) {
                self.quotedAttributedText.paragraphStyle = [PPTextParagraphStyle defaultParagraphStyle];
                self.quotedAttributedText.textParser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
                [self.quotedAttributedText resetTextStorageWithPlainText:quotedItemText];
                self.quotedAttributedText.fontSize = 15.0f;
                self.quotedAttributedText.textColor = [UIColor colorWithRed:0.388235 green:0.388235 blue:0.388235 alpha:1.0f];
            }
        }
        if (timelineItem.title) {
            NSString *title = timelineItem.title.text;
            self.titleAttributedText.paragraphStyle = [PPTextParagraphStyle defaultParagraphStyle];
            self.titleAttributedText.fontSize = [WBTimelinePreset sharedInstance].titleFontSize;
            self.titleAttributedText.textParser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
            [self.titleAttributedText resetTextStorageWithPlainText:title];
        }
        self.metaInfoAttributedText.paragraphStyle = [PPTextParagraphStyle defaultParagraphStyle];
        self.metaInfoAttributedText.textParser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
        self.metaInfoAttributedText.fontSize = 12.0f;
        [self.metaInfoAttributedText resetTextStorageWithPlainText:@"2分钟前 来自iPhone 7"];
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

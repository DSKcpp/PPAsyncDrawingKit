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
#import "NSDate+PPASDK.h"

@implementation WBTimelineTableViewCellDrawingContext
- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem
{
    if (self = [super init]) {
        _timelineItem = timelineItem;
        NSString *itemText = timelineItem.text;
        WBTimelineAttributedTextParser *parser = [WBTimelineAttributedTextParser textParserWithTimelineItem:timelineItem];
        PPTextParagraphStyle *paragraphStyle = [PPTextParagraphStyle defaultParagraphStyle];
        if (itemText) {
            _textAttributedText = [[NSMutableAttributedString alloc] initWithString:itemText];
            [_textAttributedText pp_setFont:[UIFont systemFontOfSize:16.0f]];
            [_textAttributedText pp_setColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f]];
            paragraphStyle.fontSize = 16.0f;
            [_textAttributedText pp_setTextParagraphStyle:paragraphStyle];
            [parser parserWithAttributedString:_textAttributedText];
        }
        if (timelineItem.retweeted_status) {
            NSString *quotedItemText;
            if (timelineItem.retweeted_status.user.screen_name) {
                quotedItemText = [NSString stringWithFormat:@"@%@:%@", timelineItem.retweeted_status.user.screen_name, timelineItem.retweeted_status.text];
            } else {
                quotedItemText = timelineItem.retweeted_status.text;
            }
            if (quotedItemText.length > 0) {
                _quotedAttributedText = [[NSMutableAttributedString alloc] initWithString:quotedItemText];
                [_quotedAttributedText pp_setFont:[UIFont systemFontOfSize:15.0f]];
                [_quotedAttributedText pp_setTextParagraphStyle:[PPTextParagraphStyle defaultParagraphStyle]];
                [_quotedAttributedText pp_setColor:[UIColor colorWithRed:0.388235 green:0.388235 blue:0.388235 alpha:1.0f]];
                paragraphStyle.fontSize = 15.0f;
                [_quotedAttributedText pp_setTextParagraphStyle:paragraphStyle];
                [parser parserWithAttributedString:_quotedAttributedText];
            }
        }
        if (timelineItem.title) {
            NSString *title = timelineItem.title.text;
            _titleAttributedText = [[NSMutableAttributedString alloc] initWithString:title];
            [_titleAttributedText pp_setFont:[UIFont systemFontOfSize:16.0f]];
            [_titleAttributedText pp_setTextParagraphStyle:[PPTextParagraphStyle defaultParagraphStyle]];
            [_titleAttributedText pp_setColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f]];
            paragraphStyle.fontSize = 16.0f;
            [_titleAttributedText pp_setTextParagraphStyle:paragraphStyle];
        }
        _metaInfoAttributedText = [[NSMutableAttributedString alloc] initWithString:[self source]];
        [_metaInfoAttributedText pp_setFont:[UIFont systemFontOfSize:12.0f]];
        [_metaInfoAttributedText pp_setTextParagraphStyle:[PPTextParagraphStyle defaultParagraphStyle]];
        [_metaInfoAttributedText pp_setColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f]];
        paragraphStyle.fontSize = 12.0f;
        [_metaInfoAttributedText pp_setTextParagraphStyle:paragraphStyle];
        [parser parserWithAttributedString:_metaInfoAttributedText];
    }
    return self;
}

- (NSString *)source
{
    NSString *createTime = [self stringWithTimelineDate:_timelineItem.created_at];
    NSMutableString *sourceText = [NSMutableString string];
    // 时间
    if (createTime.length) {
        [sourceText appendFormat:@"%@", createTime];
        [sourceText appendString:@"  "];
    }
    
    if (_timelineItem.source.length) {
        NSString *source = _timelineItem.source;
        // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
        static NSRegularExpression *hrefRegex, *textRegex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\").+(?=\" )" options:kNilOptions error:NULL];
            textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
        });
        NSTextCheckingResult *hrefResult, *textResult;
        NSString *href = nil, *text = nil;
        hrefResult = [hrefRegex firstMatchInString:source options:kNilOptions range:NSMakeRange(0, source.length)];
        textResult = [textRegex firstMatchInString:source options:kNilOptions range:NSMakeRange(0, source.length)];
        if (hrefResult && textResult && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound) {
            href = [_timelineItem.source substringWithRange:hrefResult.range];
            text = [_timelineItem.source substringWithRange:textResult.range];
        }
        if (href.length && text.length) {
            [sourceText appendFormat:@"来自%@", text];
            return sourceText;
//            NSMutableAttributedString *from = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自 %@", text]];
//            from.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
//            from.color = kWBCellTimeNormalColor;
//            if (_status.sourceAllowClick > 0) {
//                NSRange range = NSMakeRange(3, text.length);
//                [from setColor:kWBCellTextHighlightColor range:range];
//                YYTextBackedString *backed = [YYTextBackedString stringWithString:href];
//                [from setTextBackedString:backed range:range];
//                
//                YYTextBorder *border = [YYTextBorder new];
//                border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
//                border.fillColor = kWBCellTextHighlightBackgroundColor;
//                border.cornerRadius = 3;
//                YYTextHighlight *highlight = [YYTextHighlight new];
//                if (href) highlight.userInfo = @{kWBLinkHrefName : href};
//                [highlight setBackgroundBorder:border];
//                [from setTextHighlight:highlight range:range];
//            }
            
        }
    }
    return @"";
}

- (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        [formatterYesterday setLocale:[NSLocale currentLocale]];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"M-d"];
        [formatterSameYear setLocale:[NSLocale currentLocale]];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"yy-M-dd"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (date.isYesterday) {
        return [formatterYesterday stringFromDate:date];
    } else if (date.year == now.year) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
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

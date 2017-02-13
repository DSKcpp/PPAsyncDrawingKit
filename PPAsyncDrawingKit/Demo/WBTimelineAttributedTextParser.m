//
//  WBTimelineAttributedTextParser.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineAttributedTextParser.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "WBHelper.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "PPTextAttributes.h"
#import "WBTimelineItem.h"
#import "PPTextAttachment.h"

@implementation WBTimelineAttributedTextParser
+ (instancetype)textParserWithTimelineItem:(WBTimelineItem *)timelineItem
{
    WBTimelineAttributedTextParser *p = [self new];
    p.timelineItem = timelineItem;
    return p;
}

- (BOOL)parserWithAttributedString:(NSMutableAttributedString *)attributedString fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [attributedString pp_setFont:font];
    [attributedString pp_setColor:textColor];
    
    NSString *string = attributedString.string;
    UIColor *rangeColor = [UIColor colorWithRed:80/255.0f green:125/255.0f blue:174/255.0f alpha:1.0f];
    PPTextBorder *highlightBorder = [[PPTextBorder alloc] init];
    highlightBorder.fillColor = [UIColor colorWithRed:80/255.0f green:125/255.0f blue:174/255.0f alpha:0.5f];
    
    if (_timelineItem.url_struct) {
        for (WBURLStruct *urlStruct in _timelineItem.url_struct) {
            NSString *title = urlStruct.url_title;
            do {
                NSRange r = NSMakeRange(0, attributedString.string.length);
                NSRange range = [string rangeOfString:urlStruct.short_url options:kNilOptions range:r];
                if (range.location == NSNotFound) {
                    break;
                }
                if (range.location + range.length == r.length) {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
                    [attrString pp_setFont:[UIFont systemFontOfSize:15.0f]];
                    [attrString pp_setColor:rangeColor];
                    [attributedString replaceCharactersInRange:range withAttributedString:attrString];
                    break;
                }
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
                CGFloat fontSize = 16.0f;
                CGFloat ascent = fontSize * 0.86;
                CGFloat descent = fontSize * 0.14;
                CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
                UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
                CGSize size = CGSizeMake(fontSize, fontSize);
                CGFloat scale = 1 / 10.0;
                contentInsets.top += fontSize * scale;
                contentInsets.bottom += fontSize * scale;
                contentInsets.left += fontSize * scale;
                contentInsets.right += fontSize * scale;
                size = CGSizeMake(fontSize - fontSize * scale * 2, fontSize - fontSize * scale * 2);
//                NSURL *URL = [WBTimelineAttributedTextParser defaultURLForImageURL:urlStruct.url_type_pic];
                UIImage *image = [UIImage imageNamed:@"timeline_card_small_web"];
                PPTextAttachment *attachment = [PPTextAttachment attachmentWithContents:image type:0 contentSize:size];
                attachment.replacementText = urlStruct.short_url;
                PPTextFontMetrics *font = [[PPTextFontMetrics alloc] init];
                font.ascent = ascent;
                font.descent = descent;
                attachment.baselineFontMetrics = font;
                NSDictionary *emojiAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
                NSAttributedString *emojiAttributeString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:emojiAttributes];
                [attrString insertAttributedString:emojiAttributeString atIndex:0];
//                }
                [attrString pp_setFont:[UIFont systemFontOfSize:16.0f]];
                [attrString pp_setColor:rangeColor];
                [attributedString replaceCharactersInRange:range withAttributedString:attrString];
                PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
                [highlight setBorder:highlightBorder];
                [attributedString pp_setTextHighlightRange:highlight inRange:NSMakeRange(range.location, attrString.length)];
            } while (1);
        }
    }
    
    // At
    [string pp_enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
        [highlight setBorder:highlightBorder];
        highlight.userInfo = @{kWBLinkAt : capturedString};
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // Topic
    [string pp_enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
        [highlight setBorder:highlightBorder];
        highlight.userInfo = @{kWBLinkTopic : capturedString};
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // Email
    [string pp_enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
        [highlight setBorder:highlightBorder];
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // URL
    [string pp_enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
        [highlight setBorder:highlightBorder];
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // Emotionc
    __block NSUInteger clipLength = 0;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:nil];
    NSArray *arr = [regular matchesInString:string options:kNilOptions range:attributedString.pp_stringRange];
    for (NSTextCheckingResult *emo in arr) {
        NSRange range = emo.range;
        range.location -= clipLength;
        UIImage *image =  [[WBEmoticonManager sharedMangaer] imageWithEmotionName:[string substringWithRange:range]];
        if (image) {
            PPTextFontMetrics *fontMetrics = [[PPTextFontMetrics alloc] init];
            fontMetrics.ascent = font.ascender;
            fontMetrics.descent = -font.descender;
            CGFloat w = fontMetrics.ascent + fontMetrics.descent;
            CGSize size = CGSizeMake(w, w);
            PPTextAttachment *attachment = [PPTextAttachment attachmentWithContents:image type:UIViewContentModeScaleToFill contentSize:size];
            attachment.contentEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
            attachment.replacementText = [string substringWithRange:range];
            attachment.baselineFontMetrics = fontMetrics;
            NSDictionary *emoticonAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
            NSAttributedString *emoticonAttrString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:emoticonAttributes];
            [attributedString replaceCharactersInRange:range withAttributedString:emoticonAttrString];
            clipLength += range.length - emoticonAttrString.length;
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = fontSize + 5;
    paragraphStyle.minimumLineHeight = fontSize + 5;
    [attributedString pp_setTextParagraphStyle:paragraphStyle];
    return YES;
}

@end

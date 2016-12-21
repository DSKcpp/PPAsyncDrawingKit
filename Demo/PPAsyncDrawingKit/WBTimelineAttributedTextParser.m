//
//  WBTimelineAttributedTextParser.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineAttributedTextParser.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "PPFlavoredRange.h"
#import "WBUITextAttachment.h"
#import "WBEmoticonManager.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "PPTextHighlightRange.h"
#import "WBTimelineItem.h"

static inline CGFloat YYEmojiGetAscentWithFontSize(CGFloat fontSize) {
    if (fontSize < 16) {
        return 1.25 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        return 0.5 * fontSize + 12;
    } else {
        return fontSize;
    }
}

static inline CGFloat YYEmojiGetDescentWithFontSize(CGFloat fontSize) {
    if (fontSize < 16) {
        return 0.390625 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        return 0.15625 * fontSize + 3.75;
    } else {
        return 0.3125 * fontSize;
    }
    return 0;
}

static inline CGRect YYEmojiGetGlyphBoundingRectWithFontSize(CGFloat fontSize) {
    CGRect rect;
    rect.origin.x = 0.75;
    rect.size.width = rect.size.height = YYEmojiGetAscentWithFontSize(fontSize);
    if (fontSize < 16) {
        rect.origin.y = -0.2525 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        rect.origin.y = 0.1225 * fontSize -6;
    } else {
        rect.origin.y = -0.1275 * fontSize;
    }
    return rect;
}

@implementation WBTimelineAttributedTextParser
+ (instancetype)textParserWithTimelineItem:(WBTimelineItem *)timelineItem
{
    WBTimelineAttributedTextParser *p = [self new];
    p.timelineItem = timelineItem;
    return p;
}

- (BOOL)parserWithAttributedString:(NSMutableAttributedString *)attributedString
{
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
                [attrString pp_setFont:[UIFont systemFontOfSize:16.0f]];
                [attrString pp_setColor:rangeColor];
                PPTextHighlightRange *highlight = [PPTextHighlightRange rangeWithRange:range];
                [highlight setBorder:highlightBorder];
                [attrString pp_setTextHighlightRange:highlight inRange:NSMakeRange(0, attrString.length)];
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
                NSURL *URL = [WBTimelineAttributedTextParser defaultURLForImageURL:urlStruct.url_type_pic];
                UIImage *image = [UIImage imageNamed:@"timeline_card_small_web"];
                WBUITextAttachment *attachment = [WBUITextAttachment attachmentWithContents:image type:0 contentSize:size];
                attachment.replacementText = urlStruct.short_url;
                PPFontMetrics font;
                font.ascent = ascent;
                font.descent = descent;
                attachment.baselineFontMetrics = font;
                NSDictionary *emojiAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
                NSAttributedString *emojiAttributeString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:emojiAttributes];
                [attrString insertAttributedString:emojiAttributeString atIndex:0];
//                }
                [attributedString replaceCharactersInRange:range withAttributedString:attrString];
            } while (1);
        }
    }
    
    // At
    [string pp_enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [PPTextHighlightRange rangeWithRange:capturedRange];
        [highlight setBorder:highlightBorder];
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // Topic
    [string pp_enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [PPTextHighlightRange rangeWithRange:capturedRange];
        [highlight setBorder:highlightBorder];
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // Email
    [string pp_enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [PPTextHighlightRange rangeWithRange:capturedRange];
        [highlight setBorder:highlightBorder];
        [attributedString pp_setTextHighlightRange:highlight inRange:capturedRange];
        [attributedString pp_setColor:rangeColor inRange:capturedRange];
    }];
    // URL
    [string pp_enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPTextHighlightRange *highlight = [PPTextHighlightRange rangeWithRange:capturedRange];
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
            CGFloat fontSize = 16.0f;
            CGFloat ascent = YYEmojiGetAscentWithFontSize(fontSize);
            CGFloat descent = YYEmojiGetDescentWithFontSize(fontSize);
            CGRect bounding = YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
            PPFontMetrics font;
            font.ascent = ascent;
            font.descent = descent;
            CGFloat w =  bounding.size.width + 2 * bounding.origin.x;
            CGSize size = CGSizeMake(w, w);
            WBUITextAttachment *attachment = [WBUITextAttachment attachmentWithContents:image type:0 contentSize:size];
            attachment.replacementText = [string substringWithRange:range];
            attachment.baselineFontMetrics = font;
            NSDictionary *emoticonAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
            NSAttributedString *emoticonAttrString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:emoticonAttributes];
            [attributedString replaceCharactersInRange:range withAttributedString:emoticonAttrString];
            clipLength += range.length - emoticonAttrString.length;
        }
    }

    return YES;
}

+ (NSURL *)defaultURLForImageURL:(id)imageURL {
    /*
     微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
     
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
     */
    
    if (!imageURL) return nil;
    NSString *link = nil;
    if ([imageURL isKindOfClass:[NSURL class]]) {
        link = ((NSURL *)imageURL).absoluteString;
    } else if ([imageURL isKindOfClass:[NSString class]]) {
        link = imageURL;
    }
    if (link.length == 0) return nil;
    
    if ([link hasSuffix:@".png"]) {
        // add "_default"
        if (![link hasSuffix:@"_default.png"]) {
            NSString *sub = [link substringToIndex:link.length - 4];
            link = [sub stringByAppendingFormat:@"_default.png"];
        }
    } else {
        // replace "_y.png" with "_os7.png"
        NSRange range = [link rangeOfString:@"_y.png?version"];
        if (range.location != NSNotFound) {
            NSMutableString *mutable = link.mutableCopy;
            [mutable replaceCharactersInRange:NSMakeRange(range.location + 1, 1) withString:@"os7"];
            link = mutable;
        }
    }
    
    return [NSURL URLWithString:link];
}


@end

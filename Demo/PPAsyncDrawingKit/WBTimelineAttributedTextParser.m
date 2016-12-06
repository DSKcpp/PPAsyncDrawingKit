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

@implementation WBTimelineAttributedTextParser

- (NSArray<PPTextActiveRange *> *)parserWithString:(NSString *)string
{
    NSMutableArray<PPFlavoredRange *> *activeRanges = @[].mutableCopy;
    // At
    [string pp_enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // Topic
    [string pp_enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // Email
    [string pp_enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // URL
    [string pp_enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        textRange.flavor = PPFlavoredRangeTypeURL;
        [activeRanges addObject:textRange];
    }];
    // Emotionc
    [string pp_enumerateStringsMatchedByRegex:@"\\[[^ \\[\\]]+?\\]" usingBlock:^(NSString *capturedString, NSRange capturedRange, BOOL *stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        textRange.flavor = PPFlavoredRangeTypeEmoticon;
        [activeRanges addObject:textRange];
    }];
    return activeRanges;
}

- (nullable NSArray<PPTextActiveRange *> *)extractAttachmentsAndParseActiveRangesFromParseResult:(NSArray<PPFlavoredRange *> *)parseResult toAttributedString:(NSMutableAttributedString *)attributedString
{
    NSMutableArray<PPTextAttachment *> *textAttachments = @[].mutableCopy;
    NSMutableArray<PPFlavoredRange *> *ranges = [NSMutableArray arrayWithArray:parseResult];
    __block NSUInteger clipLength = 0;
    [parseResult enumerateObjectsUsingBlock:^(PPFlavoredRange * _Nonnull activeRange, NSUInteger idx, BOOL * _Nonnull stop) {
        if (activeRange.flavor == PPFlavoredRangeTypeURL) {
//            PPTextAttachment *attachment = [[PPTextAttachment alloc] init];
//            [attributedString addAttribute:@"PPTextAttachmentAttributeName" value:attachment range:activeRange.range];
        } else if (activeRange.flavor == PPFlavoredRangeTypeEmoticon) {
            UIImage *image =  [[WBEmoticonManager sharedMangaer] imageWithEmotionName:activeRange.content];
            CGSize size = CGSizeMake(15, 15);
            WBUITextAttachment *attachment = [WBUITextAttachment attachmentWithContents:image type:0 contentSize:size];
            attachment.replacementText = activeRange.content;
            [textAttachments addObject:attachment];
            NSRange range = activeRange.range;
            range.location -= clipLength;
            NSDictionary *emoticonAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
            NSAttributedString *emoticonAttrString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:emoticonAttributes];
            [attributedString replaceCharactersInRange:range withAttributedString:emoticonAttrString];
            clipLength += range.length - emoticonAttrString.length;
            [ranges removeObject:activeRange];
        } else {

        }
    }];
    return ranges;
}

@end

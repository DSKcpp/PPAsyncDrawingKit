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

- (NSArray<PPTextAttachment *> *)extractAttachmentsAndParseActiveRangesFromParseResult:(NSArray<PPFlavoredRange *> *)parseResult toAttributedString:(NSMutableAttributedString *)attributedString
{
    NSMutableArray<PPTextAttachment *> *textAttachments = @[].mutableCopy;
    [parseResult enumerateObjectsUsingBlock:^(PPFlavoredRange * _Nonnull activeRange, NSUInteger idx, BOOL * _Nonnull stop) {
        if (activeRange.flavor == PPFlavoredRangeTypeURL) {
//            PPTextAttachment *attachment = [[PPTextAttachment alloc] init];
//            [attributedString addAttribute:@"PPTextAttachmentAttributeName" value:attachment range:activeRange.range];
        } else if (activeRange.flavor == PPFlavoredRangeTypeEmoticon) {
            WBUITextAttachment *attachment = [[WBUITextAttachment alloc] init];
            attachment.replacementText = activeRange.content;
            attachment.contents = [[WBEmoticonManager sharedMangaer] imageWithEmotionName:activeRange.content];
            [textAttachments addObject:attachment];
        }
    }];
    
    [textAttachments enumerateObjectsUsingBlock:^(PPTextAttachment * _Nonnull textAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
//    NSInteger loc = [self mergeAttachment:attachment toAttributedString:attributedString withTextRange:activeRange.range merged:YES];
    return textAttachments;
}

- (NSInteger)mergeAttachment:(PPTextAttachment *)attachment toAttributedString:(NSMutableAttributedString *)attributedString withTextRange:(NSRange)textRange merged:(BOOL)merged
{
    NSDictionary *attributes = [attributedString attributesAtIndex:textRange.location effectiveRange:nil];
    NSAttributedString *attString = [NSAttributedString pp_attributedStringWithTextAttachment:attachment attributes:attributes];
    [attributedString replaceCharactersInRange:textRange withAttributedString:attString];
    return 1;
}
@end

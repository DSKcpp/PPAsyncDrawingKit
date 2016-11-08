//
//  PPAttributedText.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedText.h"
#import "PPTextStorage.h"
#import "PPAttributedTextParser.h"
#import "PPAttributedTextRange.h"
#import "NSMutableAttributedString+PPAsyncDrawingKit.h"
#import "UIFont+PPAsyncDrawingKit.h"
#import "NSString+PPAsyncDrawingKit.h"

@implementation PPAttributedText
{
    struct {
        unsigned int needsRebuild:1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.fontSize = 14;
        self.parseOptions = PPParseOptionsNormal | PPParseOptionsLink | PPParseOptionsMention | PPParseOptionsHashtag | PPParseOptionsEmoticon;
        self.textLigature = 1;
        self.textStorage = [[PPTextStorage alloc] init];
    }
    return self;
}

- (instancetype)initWithPlainText:(NSString *)plainText
{
    if (self = [self init]) {
        [self resetTextStorageWithPlainText:plainText];
    }
    return self;
}

- (void)resetTextStorageWithPlainText:(NSString *)plainText
{
    if (plainText == nil) {
        plainText = @"";
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:plainText];
    [self.textStorage setAttributedString:string];
}

- (void)setNeedsRebuild
{
    self.attributedString = nil;
    self.activeRanges = nil;
    self.textAttachments = nil;
    flags.needsRebuild = flags.needsRebuild | 1;
}

- (void)rebuildIfNeeded
{
    [self rebuild];
}

- (void)rebuild
{
    flags.needsRebuild = 0;
    self.textAttachments = nil;
    self.activeRanges = nil;
    NSMutableAttributedString *attributedString = [self mutableAttributedString];
    self.attributedString = attributedString;
    if (attributedString.length) {
        PPAttributedTextParser *parse = [[PPAttributedTextParser alloc] initWithPlainText:attributedString.string
                                                                           andMiniCardUrl:self.urlItems];
        PPParseOptions parseOptions = self.parseOptions;
        NSArray<PPAttributedTextRange *> *parsingResult = [parse parseWithLinkMiniCard:NO];
        parsingResult = [self filterParsingResult:parsingResult];
        [self _parseString:self.plainText withKeyword:self.keywords andCurrentParsingResult:parsingResult];
    }
}

- (NSArray<PPAttributedTextRange *> *)filterParsingResult:(NSArray<PPAttributedTextRange *> *)result
{
    return result;
}

- (NSArray<PPAttributedTextRange *> *)_parseString:(NSString *)string
                                       withKeyword:(NSArray *)keywords
                           andCurrentParsingResult:(NSArray<PPAttributedTextRange *> *)result
{
    if (keywords) {
        if (keywords.count > 0 && string) {
            if (string.length > 0) {
                NSMutableArray *arrs = [NSMutableArray array];
//                arrs addObjectsFromArray:<#(nonnull NSArray *)#>
            }
        }
    }
    return result;
}

- (NSMutableAttributedString *)mutableAttributedString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.plainText];
    if (attributedString.length) {
        if (self.textColor) {
            [attributedString pp_setColor:self.textColor];
        }
    }
    NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    CTFontRef font;
    if (systemVersion < 9) {
        font = [UIFont pp_newCTFontWithName:@"" size:self.fontSize];
    } else {
        UIFont *systemFont = [UIFont systemFontOfSize:self.fontSize];
        font = [UIFont pp_newCTFontWithName:[systemFont fontName] size:self.fontSize];
    }
    [attributedString pp_setCTFont:font];
    NSRange range = [self.textStorage pp_stringRange];
    NSArray<NSString *> *attributeKeys = @[(NSString *)kCTFontAttributeName,
                                           (NSString *)kCTForegroundColorAttributeName,
                                           (NSString *)kCTUnderlineStyleAttributeName,
                                           (NSString *)kCTParagraphStyleAttributeName,
                                           (NSString *)kCTRunDelegateAttributeName,
                                           @"PPTextAttachmentAttributeName",
                                           @"PPTextBackgroundColorAttributeName",
                                           @"PPTextComposedSequenceAttributeName"];
    for (NSString *key in attributeKeys) {
        [self.textStorage enumerateAttribute:key
                                     inRange:range
                                     options:NSAttributedStringEnumerationReverse
                                  usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                      NSLog(@"[%@] - %@", value, NSStringFromRange(range));
                                      if (value) {
                                          SEL sel = @selector(integerValue);
                                          if ([value respondsToSelector:sel] && [value integerValue]) {
                                              
                                          }
                                      }
                                  }];
    }
    return attributedString;
}

- (NSString *)plainText
{
    return self.textStorage.string;
}

- (id)parseActiveRangesFromString:(NSString *)string
{
    NSMutableArray *activeRanges = @[].mutableCopy;
    // At
    [string pp_enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // Topic
    [string pp_enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // Email
    [string pp_enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // URL
    [string pp_enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    return activeRanges;
}
@end

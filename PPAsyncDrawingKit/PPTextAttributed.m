//
//  PPTextAttributed.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextAttributed.h"
#import "PPTextStorage.h"
#import "PPAttributedTextRange.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "PPTextAttachment.h"

@implementation PPTextAttributed
{
    struct {
        unsigned int needsRebuild:1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.fontSize = 16.0f;
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
    flags.needsRebuild = 1;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:plainText];
    [self.textStorage setAttributedString:string];
}

- (void)setNeedsRebuild
{
    self.attributedString = nil;
    self.activeRanges = nil;
    self.textAttachments = nil;
    flags.needsRebuild = 1;
}

- (void)rebuildIfNeeded
{
    if (flags.needsRebuild == 1) {
        [self rebuild];
    }
}

- (NSMutableAttributedString *)attributedString
{
    [self rebuildIfNeeded];
    return _attributedString;
}

- (void)rebuild
{
    flags.needsRebuild = 0;
    self.textAttachments = nil;
    self.activeRanges = nil;
    NSMutableAttributedString *attributedString = [self mutableAttributedString];
    if (attributedString.length) {
        NSArray<PPTextActiveRange *> *parsingResult = [self.textParser parserWithString:attributedString.string];
        if ([self.textParser respondsToSelector:@selector(extractAttachmentsAndParseActiveRangesFromParseResult:toAttributedString:)]) {
            self.textAttachments = [self.textParser extractAttachmentsAndParseActiveRangesFromParseResult:parsingResult toAttributedString:attributedString];
        }
        parsingResult = [self filterParsingResult:parsingResult];
        parsingResult = [self _parseString:self.plainText withKeyword:self.keywords andCurrentParsingResult:parsingResult];
        self.activeRanges = parsingResult;
        for (PPTextActiveRange *range in self.activeRanges) {
            [self setColorWithActiveRange:range forAttributedString:attributedString];
        }
        [self updateParagraphStyleForAttributedString:attributedString];
    }
    [self updatePlainTextForCharacterCountingWithAttributedString:attributedString];
    self.attributedString = attributedString;
}

- (void)updateParagraphStyleForAttributedString:(NSMutableAttributedString *)attributedString
{
    CTParagraphStyleRef paragraphSetle = [self.paragraphStyle newCTParagraphStyleWithFontSize:self.fontSize];
    if (attributedString) {
        [attributedString addAttribute:NSParagraphStyleAttributeName value:(id)paragraphSetle range:[attributedString pp_stringRange]];
    }
    CFRelease(paragraphSetle);
}

- (void)updatePlainTextForCharacterCountingWithAttributedString:(NSMutableAttributedString *)attributedString
{
    NSMutableAttributedString *_attributedString = attributedString.mutableCopy;
    [_attributedString enumerateAttribute:@"_WBTimelineAttributedTextLinkMarkKey" inRange:[_attributedString pp_stringRange] options:kNilOptions usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        *stop = YES;
    }];
}

- (void)setColorWithActiveRange:(PPTextActiveRange *)activeRange forAttributedString:(NSMutableAttributedString *)attributedString
{
    if (activeRange) {
        [attributedString pp_setColor:[UIColor colorWithRed:80/255.0f green:125/255.0f blue:174/255.0f alpha:1.0f] inRange:activeRange.range];
    }
}

- (NSInteger)mergeAttachment:(PPTextAttachment *)attachment toAttributedString:(NSMutableAttributedString *)attributedString withTextRange:(NSRange)textRange merged:(BOOL)merged
{
    if (attachment) {
        NSInteger r = 1;
        if (textRange.location + textRange.length >= textRange.location) {
            r = 0;
        }
        if (!r && textRange.location + textRange.length <= attributedString.length) {
            if (!self.shouldShowSmallCardForcily && attachment) {
                
            }
        }
    }
    return 0;
}

- (NSArray<PPTextActiveRange *> *)filterParsingResult:(NSArray<PPTextActiveRange *> *)result
{
    return result;
}

- (NSArray<PPTextActiveRange *> *)_parseString:(NSString *)string
                                       withKeyword:(NSArray *)keywords
                           andCurrentParsingResult:(NSArray<PPTextActiveRange *> *)result
{
//    if (keywords) {
//        if (keywords.count > 0 && string) {
//            if (string.length > 0) {
//                
//                NSMutableArray *arrs = [NSMutableArray array];
////                arrs addObjectsFromArray:<#(nonnull NSArray *)#>
//            }
//        }
//    }
    return result;
}

- (NSMutableAttributedString *)mutableAttributedString
{
    NSString *plainText = self.plainText;
    if (plainText) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.plainText];
        if (attributedString.length) {
            if (self.textColor) {
                [attributedString pp_setColor:self.textColor];
            }
        }
        [attributedString pp_setFont:[UIFont systemFontOfSize:self.fontSize]];
        NSRange range = [attributedString pp_stringRange];
        if (self.textLigature != 1) {
            NSNumber *textLigature = [NSNumber numberWithUnsignedInteger:self.textLigature];
            [attributedString addAttribute:NSLigatureAttributeName value:textLigature range:range];
        }
//        NSArray<NSString *> *attributeKeys = @[(NSString *)kCTFontAttributeName,
//                                               (NSString *)kCTForegroundColorAttributeName,
//                                               (NSString *)kCTUnderlineStyleAttributeName,
//                                               (NSString *)kCTParagraphStyleAttributeName,
//                                               (NSString *)kCTRunDelegateAttributeName,
//                                               @"PPTextAttachmentAttributeName",
//                                               @"PPTextBackgroundColorAttributeName",
//                                               @"PPTextComposedSequenceAttributeName"];
        
        [self.textStorage enumerateAttribute:@"WBTimelineAttributedTextFontSymbolicTraitsKey" inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            *stop = YES;
        }];
        return attributedString;
    } else {
        return nil;
    }
}

- (NSString *)plainText
{
    return self.textStorage.string;
}

@end

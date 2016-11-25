//
//  PPAttributedText.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedText.h"
#import "PPTextStorage.h"
#import "PPAttributedTextRange.h"
#import "NSMutableAttributedString+PPAsyncDrawingKit.h"
#import "UIFont+PPAsyncDrawingKit.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "PPTextAttachment.h"

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
    flags.needsRebuild = 1;
}

- (void)rebuildIfNeeded
{
    [self rebuild];
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
        NSArray<id<PPTextActiveRange>> *parsingResult = [self.textParser parserWithString:attributedString.string];
        parsingResult = [self filterParsingResult:parsingResult];
        parsingResult = [self _parseString:self.plainText withKeyword:self.keywords andCurrentParsingResult:parsingResult];
        [self extractAttachmentsAndParseActiveRangesFromParseResult:parsingResult toAttributedString:attributedString];
        for (id<PPTextActiveRange> range in self.activeRanges) {
            [self setColorWithActiveRange:range forAttributedString:attributedString];
        }
        [self updateParagraphStyleForAttributedString:attributedString];
    }
    [self updatePlainTextForCharacterCountingWithAttributedString:attributedString];
    self.attributedString = attributedString;
}

- (void)updateParagraphStyleForAttributedString:(NSMutableAttributedString *)attributedString
{
    
}

- (void)updatePlainTextForCharacterCountingWithAttributedString:(NSMutableAttributedString *)attributedString
{
    NSMutableAttributedString *_attributedString = attributedString.mutableCopy;
    [_attributedString enumerateAttribute:@"_WBTimelineAttributedTextLinkMarkKey" inRange:[_attributedString pp_stringRange] options:kNilOptions usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        *stop = YES;
    }];
}

- (void)extractAttachmentsAndParseActiveRangesFromParseResult:(NSArray<id<PPTextActiveRange>> *)parseResult toAttributedString:(NSMutableAttributedString *)attributedString
{
    NSMutableArray *activeRanges = [NSMutableArray array];
//    for (PPAttributedTextRange *range in parseResult) {
//        switch (range.mode) {
//            case PPAttributedTextRangeModeMention: {
//                 PPFlavoredRange *flavoredRange = [[PPFlavoredRange alloc] init];
//                flavoredRange.range = NSMakeRange(range.location, range.length);
//                flavoredRange.flavor = PPAttributedTextRangeModeMention;
//                [activeRanges addObject:flavoredRange];
//            }
//                break;
//            case PPAttributedTextRangeModeLink:
//                break;
//            case PPAttributedTextRangeModeHashtag: {
//                PPFlavoredRange *flavoredRange = [[PPFlavoredRange alloc] init];
//                flavoredRange.range = NSMakeRange(range.location, range.length);
//                flavoredRange.flavor = PPAttributedTextRangeModeHashtag;
//                [activeRanges addObject:flavoredRange];
//            }
//                break;
//            case PPAttributedTextRangeModeDollartag:
//                break;
//            case PPAttributedTextRangeModeEmoticon:
//                break;
//            case PPAttributedTextRangeModeMiniCard:
//                break;
//            default:
//                break;
//        }
//    }
    self.activeRanges = [NSArray arrayWithArray:parseResult];
}

- (void)setColorWithActiveRange:(id<PPTextActiveRange>)activeRange forAttributedString:(NSMutableAttributedString *)attributedString
{
    if (activeRange) {
        [attributedString pp_setColor:[UIColor blueColor] inRange:activeRange.range];
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

- (NSArray<id<PPTextActiveRange>> *)filterParsingResult:(NSArray<id<PPTextActiveRange>> *)result
{
    return result;
}

- (NSArray<id<PPTextActiveRange>> *)_parseString:(NSString *)string
                                       withKeyword:(NSArray *)keywords
                           andCurrentParsingResult:(NSArray<id<PPTextActiveRange>> *)result
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
        NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
        CTFontRef font;
        if (systemVersion < 9) {
            font = [UIFont pp_newCTFontWithName:@"HelveticaNeue" size:self.fontSize];
        } else {
            UIFont *systemFont = [UIFont systemFontOfSize:self.fontSize];
            font = [UIFont pp_newCTFontWithName:[systemFont fontName] size:self.fontSize];
        }
        [attributedString pp_setCTFont:font];
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

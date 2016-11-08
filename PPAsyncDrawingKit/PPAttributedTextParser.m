//
//  PPAttributedTextParser.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedTextParser.h"
#import "PPAttributedTextRange.h"
#import "PPAttributedTextParseStack.h"

@implementation PPAttributedTextParser
- (instancetype)initWithPlainText:(NSString *)text
{
    return [self initWithPlainText:text andMiniCardUrl:nil];
}

- (instancetype)initWithPlainText:(NSString *)text andMiniCardUrl:(NSArray *)miniCardUrl
{
    if (self = [super init]) {
        self.plainText = text;
        self.parsedRanges = @[].mutableCopy;
        self.miniCardUrlItems = miniCardUrl;
        self.parseRangeStack = [[PPAttributedTextParseStack alloc] init];
    }
    return self;
}

- (NSArray<PPAttributedTextRange *> *)parseWithLinkMiniCard:(BOOL)arg1
{
    [self parsePhoneNumber];
    [self parseAllModesExceptMiniCardMode];
    [self parseEmailAdressModeFromMentionModeResult];
    return [NSArray arrayWithArray:self.parsedRanges];
}

- (void)parsePhoneNumber
{
    NSError *error;
    NSString *pattern = @"(\\+?)((\\d{7,16})|(((\\d{1,16})(-{1}|\\s{1}))+(\\d{1,16})))";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    NSUInteger length = self.plainText.length;
    if (length) {
        [regularExpression enumerateMatchesInString:self.plainText options:kNilOptions range:NSMakeRange(0, length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSRange range = result.range;
            PPAttributedTextRange *attRange = [PPAttributedTextRange rangeWithMode:PPAttributedTextRangeModeNormal
                                                                       andLocation:range.location];
            attRange.length = range.length;
            [self.parsedRanges addObject:attRange];
        }];
    }
}

- (void)parseAllModesExceptMiniCardMode
{
    NSUInteger length = self.plainText.length;
    if (length) {
        for (NSInteger i = 0; i < length; i++) {
            [self parseAtIndex:i];
        }
    }
}

- (void)parseEmailAdressModeFromMentionModeResult
{
    
}

- (PPAttributedTextRange *)beginNewRangeWithMode:(PPAttributedTextRangeMode)mode atIndex:(NSUInteger)index
{
    PPAttributedTextRange *range = [PPAttributedTextRange rangeWithMode:mode andLocation:index];
    [self.parseRangeStack push:range];
    return range;
}

- (void)finishParseCurrentRangeAtIndex:(NSUInteger)index
{
    PPAttributedTextRange *range = [self.parseRangeStack pop];
    [self finishParseRange:range atIndex:index];
}

- (void)finishParseRange:(PPAttributedTextRange *)range atIndex:(NSUInteger)index
{
    NSUInteger location = range.location;
    range.length = index - location;
    NSString *content = [self.plainText substringWithRange:NSMakeRange(range.location, range.length)];
    range.content = content;
    if (range.mode != PPAttributedTextRangeModeNormal) {
        [self.parsedRanges addObject:range];
    }
}

- (NSUInteger)tryEnterLinkModeAtIndex:(NSUInteger)index shouldFinishCurrentRange:(BOOL)arg2
{
    NSUInteger (^block)() = ^NSUInteger() {
        return 0;
    };
    return block();
}

- (NSUInteger)parseAtIndex:(NSUInteger)index
{
    PPAttributedTextRange *parsingRange = [self.parseRangeStack parsingRange];
    PPAttributedTextRange *newRange = [self beginNewRangeWithMode:parsingRange.mode atIndex:index];
    NSUInteger i = 0;
    switch (newRange.mode) {
        case PPAttributedTextRangeModeNormal:
            i = [self parseNormalModeAtIndex:index];
            break;
        case PPAttributedTextRangeModeMention:
            i = [self parseMentionModeAtIndex:index];
            break;
        case PPAttributedTextRangeModeLink:
            i = [self parseLinkModeAtIndex:index];
            break;
        case PPAttributedTextRangeModeHashtag:
            i = [self parseHashtagModeAtIndex:index];
            break;
        case PPAttributedTextRangeModeDollartag:
            i = [self parseDollartagModeAtIndex:index];
            break;
        case PPAttributedTextRangeModeEmoticon:
            i = [self parseEmoticonModeAtIndex:index];
            break;
        default:
            break;
    }
    return i;
}

- (NSUInteger)parseNormalModeAtIndex:(NSUInteger)index
{
    unichar unichar = [self.plainText characterAtIndex:index];
    if (unichar > 71) {
        if (unichar == 72) {
            return [self tryEnterLinkModeAtIndex:index shouldFinishCurrentRange:YES];
        } else if (unichar == 91) {
            [self finishParseCurrentRangeAtIndex:index];
            [self beginNewRangeWithMode:PPAttributedTextRangeModeNormal atIndex:index];
        } else if (unichar == 104) {
            return [self tryEnterLinkModeAtIndex:index shouldFinishCurrentRange:YES];
        }
    } else {
        if (unichar == 35) {
            [self finishParseCurrentRangeAtIndex:index];
            [self beginNewRangeWithMode:PPAttributedTextRangeModeHashtag atIndex:index];
        } else if (unichar == 36) {
            [self finishParseCurrentRangeAtIndex:index];
            [self beginNewRangeWithMode:PPAttributedTextRangeModeDollartag atIndex:index];
        } else if (unichar == 64) {
            [self finishParseCurrentRangeAtIndex:index];
            [self beginNewRangeWithMode:PPAttributedTextRangeModeNormal atIndex:index];
        }
    }
    return 0;
}

@end

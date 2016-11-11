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
#import "NSString+PPAsyncDrawingKit.h"

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
    PPAttributedTextRange *hashtag = [PPAttributedTextRange rangeWithMode:PPAttributedTextRangeModeHashtag andLocation:0];
    hashtag.length = 6;
    hashtag.content = @"#纽约漫展#";
    PPAttributedTextRange *mention = [PPAttributedTextRange rangeWithMode:PPAttributedTextRangeModeMention andLocation:16];
    mention.length = 5;
    mention.content = @"@陈一发儿";
    return @[hashtag, mention];
//    return [NSArray arrayWithArray:self.parsedRanges];
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
            NSUInteger j = [self parseAtIndex:i];
        }
    }
    NSLog(@"%@", self.parsedRanges);
    PPAttributedTextRange *parsingRange = self.parseRangeStack.parsingRange;
    if (parsingRange) {
        if (parsingRange.mode <= 10) {
            [self finishParseCurrentRangeAtIndex:0];
            PPAttributedTextRange *parsingRange = self.parseRangeStack.parsingRange;
            if (!parsingRange) {
                return;
            }
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
    NSLog(@"%d", unichar);
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

- (NSUInteger)parseEmoticonModeAtIndex:(NSUInteger)index
{
    return 0;
}

- (NSUInteger)parseMentionModeAtIndex:(NSUInteger)index
{
    NSUInteger result = 0;
    NSString *text = [self.plainText substringWithRange:NSMakeRange(index, 1)];
    if ([text pp_isMatchedByRegex:@"[\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-\\x{b7}]"]) {
        unichar unichar = [self.plainText characterAtIndex:index];
        if ((unichar | 32) == 104) {
            result = [self tryEnterLinkModeAtIndex:index shouldFinishCurrentRange:YES];
        }
    } else {
        [self finishParseCurrentRangeAtIndex:index];
        result = [self parseAtIndex:index];
    }
    NSLog(@"%zu", result);
    return result;
}

- (NSUInteger)parseHashtagModeAtIndex:(NSUInteger)index
{
    unichar unichar = [self.plainText characterAtIndex:index];
    NSLog(@"%d", unichar);
    if (unichar > 71) {
        if (unichar <= 92) {
            if (unichar != 72) {
                if (unichar == 91) {
                    [self beginNewRangeWithMode:PPAttributedTextRangeModeEmoticon atIndex:index];
                    return 0;
                }
            }
            return 0;
        } else if (unichar != 93) {
            if (unichar != 104) {
                return 0;
            }
            return [self tryEnterLinkModeAtIndex:index shouldFinishCurrentRange:NO];
        }
        return [self tryEnterLinkModeAtIndex:index shouldFinishCurrentRange:NO];
    } else if (unichar == 35) {
        
    }
    return index;
}

@end

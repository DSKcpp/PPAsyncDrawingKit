//
//  WBTimelineAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAttributedTextRange.h"
#import "PPAttributedText.h"

@class PPAttributedTextParseStack;

@interface WBTimelineAttributedTextParser : NSObject <PPTextParser>

@property (nonatomic, strong) NSMutableArray<PPAttributedTextRange *> *parsedRanges;
@property (nonatomic, strong) PPAttributedTextParseStack *parseRangeStack;
@property (nonatomic, copy) NSString *plainText;
@property (nonatomic, strong) NSArray *miniCardUrlItems;
- (void)parseEmailAdressModeFromMentionModeResult;
- (void)parseAllModesExceptMiniCardMode;
- (void)parseMiniCardModeWithLink:(BOOL)arg1;
- (void)parsePhoneNumber;
- (NSUInteger)parseAtIndex:(NSUInteger)index;
- (NSUInteger)parseNormalModeAtIndex:(NSUInteger)index;
- (NSUInteger)parseMentionModeAtIndex:(NSUInteger)index;
- (NSUInteger)parseEmoticonModeAtIndex:(NSUInteger)index;
- (NSUInteger)parseDollartagModeAtIndex:(NSUInteger)index;
- (NSUInteger)parseHashtagModeAtIndex:(NSUInteger)index;
- (NSUInteger)parseLinkModeAtIndex:(NSUInteger)index;
- (NSUInteger)tryEnterLinkModeAtIndex:(NSUInteger)index shouldFinishCurrentRange:(BOOL)arg2;
- (PPAttributedTextRange *)beginNewRangeWithMode:(PPAttributedTextRangeMode)mode atIndex:(NSUInteger)index;
- (void)finishParseRange:(PPAttributedTextRange *)range atIndex:(NSUInteger)index;
- (void)finishParseCurrentRangeAtIndex:(NSUInteger)index;

@end

@interface PPAttributedTextParseStack : NSObject
@property (nonatomic, strong) PPAttributedTextRange *firstEmotionRange;
@property (nonatomic, strong) PPAttributedTextRange *firstDollartagRange;
@property (nonatomic, strong) PPAttributedTextRange *firstHashtagRange;
@property (nonatomic, strong) NSMutableArray<PPAttributedTextRange *> *ranges;

- (PPAttributedTextRange *)parsingRange;
- (void)push:(PPAttributedTextRange *)range;
- (PPAttributedTextRange *)pop;
- (PPAttributedTextRange *)popToMode:(PPAttributedTextRangeMode)model;
@end

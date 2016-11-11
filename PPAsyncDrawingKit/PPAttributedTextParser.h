//
//  PPAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAttributedTextRange.h"

@class PPAttributedTextParseStack;

@interface PPAttributedTextParser : NSObject

@property (nonatomic, strong) NSMutableArray<PPAttributedTextRange *> *parsedRanges;
@property (nonatomic, strong) PPAttributedTextParseStack *parseRangeStack;
@property (nonatomic, copy) NSString *plainText;
@property (nonatomic, strong) NSArray *miniCardUrlItems;
+ (void)test;
- (instancetype)initWithPlainText:(NSString *)text;
- (instancetype)initWithPlainText:(NSString *)text andMiniCardUrl:(NSArray *)miniCardUrl;
- (NSArray<PPAttributedTextRange *> *)parseWithLinkMiniCard:(BOOL)arg1;
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

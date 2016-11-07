//
//  PPAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPAttributedTextParser : NSObject

@property(retain, nonatomic) NSMutableArray *parsedRanges;
//@property(retain, nonatomic) WBTimelineAttributedTextParseStack *parseRangeStack; // @synthesize parseRangeStack=_parseRangeStack;
@property(copy, nonatomic) NSString *plainText;
@property(retain, nonatomic) NSArray *miniCardUrlItems;
+ (void)test;
- (id)parseWithLinkMiniCard:(BOOL)arg1;
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
- (id)beginNewRangeWithMode:(NSUInteger)mode atIndex:(NSUInteger)index;
- (void)finishParseRange:(id)arg1 atIndex:(NSUInteger)index;
- (void)finishParseCurrentRangeAtIndex:(NSUInteger)index;
- (instancetype)initWithPlainText:(NSString *)text andMiniCardUrl:(NSArray *)arg2;
- (instancetype)initWithPlainText:(NSString *)text;
@end

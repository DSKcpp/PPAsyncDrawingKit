//
//  PPAttributedTextParser.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedTextParser.h"

@implementation PPAttributedTextParser
- (instancetype)initWithPlainText:(NSString *)text
{
    return [self initWithPlainText:text andMiniCardUrl:nil];
}

- (instancetype)initWithPlainText:(NSString *)text andMiniCardUrl:(NSArray *)arg2
{
    if (self = [super init]) {
        self.plainText = text;
        self.parsedRanges = @[].mutableCopy;
        self.miniCardUrlItems = arg2;
    }
    return self;
}

//- (NSUInteger)parseAtIndex:(NSUInteger)index
//{
//    
//}
//
//- (NSUInteger)parseMentionModeAtIndex:(NSUInteger)index
//{
//    NSString *substring = [self.plainText substringWithRange:NSMakeRange(index, 1)];
//    
//}
@end

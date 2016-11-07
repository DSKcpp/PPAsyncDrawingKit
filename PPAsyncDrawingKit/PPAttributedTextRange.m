//
//  PPAttributedTextRange.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/7.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedTextRange.h"

@implementation PPAttributedTextRange
+ (instancetype)rangeWithMode:(PPAttributedTextRangeModel)mode andLocation:(NSUInteger)locaiton
{
    PPAttributedTextRange *range = [[PPAttributedTextRange alloc] init];
    range.mode = mode;
    range.location = locaiton;
    range.length = 0;
    return range;
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    if (self.mode < 9) {
        switch (self.mode) {
            case PPAttributedTextRangeModelNormal:
                [string appendString:@"Normal"];
                break;
            case PPAttributedTextRangeModelMention:
                [string appendString:@"Mention"];
            case PPAttributedTextRangeModelLink:
                [string appendString:@"Link"];
            case PPAttributedTextRangeModelHashtag:
                [string appendString:@"Hashtag"];
            case PPAttributedTextRangeModelDollartag:
                [string appendString:@"Dollartag"];
            case PPAttributedTextRangeModelEmoticon:
                [string appendString:@"Emoticon"];
            case PPAttributedTextRangeModelDictation:
                [string appendString:@"Dictation"];
            case PPAttributedTextRangeModelMiniCard:
                [string appendString:@"MiniCard"];
            case PPAttributedTextRangeModelEmailAdress:
                [string appendString:@"EmailAdress"];
        }
    }
    [string appendFormat:@" s=%lu l=%lu c=%@", self.location, self.length, self.content];
    return string;
}

- (void)dealloc
{
    self.contentAttachment = nil;
}
@end

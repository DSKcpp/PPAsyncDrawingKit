//
//  PPAttributedTextRange.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/7.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedTextRange.h"

@implementation PPAttributedTextRange
+ (instancetype)rangeWithMode:(PPAttributedTextRangeMode)mode andLocation:(NSUInteger)locaiton
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
            case PPAttributedTextRangeModeNormal:
                [string appendString:@"Normal"];
                break;
            case PPAttributedTextRangeModeMention:
                [string appendString:@"Mention"];
                break;
            case PPAttributedTextRangeModeLink:
                [string appendString:@"Link"];
                break;
            case PPAttributedTextRangeModeHashtag:
                [string appendString:@"Hashtag"];
                break;
            case PPAttributedTextRangeModeDollartag:
                [string appendString:@"Dollartag"];
                break;
            case PPAttributedTextRangeModeEmoticon:
                [string appendString:@"Emoticon"];
                break;
            case PPAttributedTextRangeModeDictation:
                [string appendString:@"Dictation"];
                break;
            case PPAttributedTextRangeModeMiniCard:
                [string appendString:@"MiniCard"];
                break;
            case PPAttributedTextRangeModeEmailAdress:
                [string appendString:@"EmailAdress"];
                break;
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

//
//  PPAttributedTextParseStack.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedTextParseStack.h"

@implementation PPAttributedTextParseStack

- (PPAttributedTextRange *)parsingRange
{
    return self.ranges.lastObject;
}

- (void)push:(PPAttributedTextRange *)range
{
    if (!self.ranges) {
        self.ranges = [NSMutableArray array];
    }
    if (range.mode != PPAttributedTextRangeModeHashtag) {
        
    } else {
        
    }
    [self.ranges addObject:range];
}

- (PPAttributedTextRange *)pop
{
    PPAttributedTextRange *laseRange = self.ranges.lastObject;
    [self.ranges removeLastObject];
    return laseRange;
}

- (PPAttributedTextRange *)popToMode:(PPAttributedTextRangeMode)model
{
    return [self pop];
}

- (NSString *)description
{
    return [self.ranges description];
}
@end

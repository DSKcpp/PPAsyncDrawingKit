//
//  NSNumber+Formatter.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/18.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "NSNumber+Formatter.h"

@implementation NSNumber (Formatter)
- (NSString *)formatterCountToString
{
    NSUInteger count = self.unsignedIntegerValue;
    NSString *countString = @"";
    
    if (count < 10000) {
        countString = @(count).stringValue;
    } else if (count < 100000000) {
        countString = [NSString stringWithFormat:@"%tu万", (count/10000)];
    }
    return countString;
}
@end

//
//  NSString+Regex.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)
- (BOOL)pp_isMatchedByRegex:(NSString *)regex
{
    return [self pp_isMatchedByRegex:regex inRange:NSMakeRange(0, self.length)];
}

- (BOOL)pp_isMatchedByRegex:(NSString *)regex inRange:(NSRange)range
{
    return [self pp_isMatchedByRegex:regex options:kNilOptions inRange:range error:nil];
}

- (BOOL)pp_isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError *__autoreleasing *)error
{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:options error:error];
    if (error) {
        NSLog(@"Regex Error: %@", *error);
        return NO;
    }
    NSTextCheckingResult *result = [regular firstMatchInString:regex options:kNilOptions range:range];
    return result != nil;
}

- (void)pp_enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString * _Nonnull, NSRange, BOOL * _Nonnull))block
{
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Regex Error: %@", error);
    }
    [regular enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *subText = [self substringWithRange:result.range];
        block(subText, result.range, stop);
    }];
}
@end

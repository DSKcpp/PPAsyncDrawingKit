//
//  WBTimelineAttributedTextParser.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineAttributedTextParser.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "PPFlavoredRange.h"

@implementation WBTimelineAttributedTextParser

- (NSArray<PPTextActiveRange *> *)parserWithString:(NSString *)string
{
    NSMutableArray<PPFlavoredRange *> *activeRanges = @[].mutableCopy;
    // At
    [string pp_enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // Topic
    [string pp_enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // Email
    [string pp_enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    // URL
    [string pp_enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        PPFlavoredRange *textRange = [[PPFlavoredRange alloc] init];
        textRange.range = capturedRange;
        textRange.content = capturedString;
        [activeRanges addObject:textRange];
    }];
    return activeRanges;
}

@end

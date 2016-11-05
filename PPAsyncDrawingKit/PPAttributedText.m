//
//  PPAttributedText.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedText.h"
#import "PPTextStorage.h"
#import "PPAsyncDrawingKitUtilities.h"

@implementation PPAttributedText
{
    struct {
        unsigned int needsRebuild:1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.fontSize = 14;
        self.parseOptions = 0x13d;
        self.textLigature = 1;
        self.textStorage = [[PPTextStorage alloc] init];
    }
    return self;
}

- (instancetype)initWithPlainText:(NSString *)plainText
{
    if (self = [self init]) {
        [self resetTextStorageWithPlainText:plainText];
    }
    return self;
}

- (void)resetTextStorageWithPlainText:(NSString *)plainText
{
    if (plainText == nil) {
        plainText = @"";
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:plainText];
    [self.textStorage setAttributedString:string];
}

- (void)setNeedsRebuild
{
    self.attributedString = nil;
    self.activeRanges = nil;
    self.textAttachments = nil;
    flags.needsRebuild = flags.needsRebuild | 1;
}

- (void)rebuildIfNeeded
{
    [self rebuild];
}

- (void)rebuild
{
    flags.needsRebuild = 0;
    self.textAttachments = nil;
    self.activeRanges = nil;
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:self.textStorage.string];
//    if ([self.mutableAttributedString length]) {
//        
//    }
}

- (NSString *)plainText
{
    return self.textStorage.string;
}

- (id)parseActiveRangesFromString:(NSString *)string
{
    NSMutableArray *activeRanges = @[].mutableCopy;
    // At
    [string enumerateStringsMatchedByRegex:@"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // Topic
    [string enumerateStringsMatchedByRegex:@"#([^#]+?)#" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // Email
    [string enumerateStringsMatchedByRegex:@"([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    // URL
    [string enumerateStringsMatchedByRegex:@"(?i)https?://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\(\\)/,:;@&=\?~#%]*)*" usingBlock:^(NSString * _Nonnull capturedString, NSRange capturedRange, BOOL * _Nonnull stop) {
        NSLog(@"[%@] - %@", capturedString, NSStringFromRange(capturedRange));
    }];
    return activeRanges;
}
@end

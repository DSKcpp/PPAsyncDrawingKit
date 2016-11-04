//
//  PPAttributedText.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAttributedText.h"
#import "PPTextStorage.h"

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

- (NSString *)plainText
{
    return self.textStorage.string;
}
@end

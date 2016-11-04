//
//  PPTextStorage.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextStorage.h"
#import "PPAsyncDrawingKitUtilities.h"

@interface PPTextStorage ()
@property (nonatomic, assign) CFMutableAttributedStringRef attributedString;
@end

@implementation PPTextStorage
{
    struct {
        unsigned int didProcessEditing: 1;
    } delegateHas;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.attributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    }
    return self;
}

- (void)setDelegate:(id<PPTextStorageDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        delegateHas.didProcessEditing = [delegate respondsToSelector:@selector(pp_textStorage:didProcessEditing:range:changeInLength:)];
    }
}

- (NSString *)string
{
    if (self.attributedString) {
        CFStringRef string =  CFAttributedStringGetString(self.attributedString);
        return (__bridge NSString *)string;
    }
    return @"";
}


- (id)attribute:(NSString *)attrName atIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    if (self.attributedString) {
        if (self.length >= location) {
            CFRange _range = PPCFRangeFromNSRange(*range);
            return (__bridge NSDictionary *)CFAttributedStringGetAttributes(self.attributedString, location, &_range);
        }
    }
    return nil;
}

- (void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range
{
    CFAttributedStringSetAttributes(self.attributedString, PPCFRangeFromNSRange(range), (__bridge CFDictionaryRef)attrs, NO);
    if (delegateHas.didProcessEditing != 0) {
        [self.delegate pp_textStorage:self didProcessEditing:1 range:range changeInLength:0];
    }
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    if (str == nil && range.length == self.length) {
        str = nil;
    }
    CFAttributedStringReplaceString(self.attributedString, PPCFRangeFromNSRange(range), (__bridge CFStringRef)str);
    if (delegateHas.didProcessEditing != 0) {
        [self.delegate pp_textStorage:self didProcessEditing:1 range:range changeInLength:0];
    }
}

@end

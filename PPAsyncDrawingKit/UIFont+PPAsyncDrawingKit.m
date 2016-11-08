//
//  UIFont+PPAsyncDrawingKit.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "UIFont+PPAsyncDrawingKit.h"

@implementation UIFont (PPAsyncDrawingKit)
static CTFontDescriptorRef arialMTFontDescriptor;
static CTFontDescriptorRef appleColorEmojiFontDescriptor;
static CTFontDescriptorRef zapfDingbatsITCFontDescriptor;
static CTFontDescriptorRef systemFontDescriptor;

+ (void)pp_createFontDescriptors
{
    if (arialMTFontDescriptor) {
        CFRelease(arialMTFontDescriptor);
        arialMTFontDescriptor = NULL;
    }
    if (appleColorEmojiFontDescriptor) {
        CFRelease(appleColorEmojiFontDescriptor);
        appleColorEmojiFontDescriptor = NULL;
    }
    if (zapfDingbatsITCFontDescriptor) {
        CFRelease(zapfDingbatsITCFontDescriptor);
        zapfDingbatsITCFontDescriptor = NULL;
    }
    if (systemFontDescriptor) {
        CFRelease(systemFontDescriptor);
        systemFontDescriptor = NULL;
    }
    NSDictionary *arialMTAttribtues = @{(NSString *)kCTFontNameAttribute : @"ArialMT"};
    arialMTFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)arialMTAttribtues);
    NSDictionary *appleColorEmojiAttribtues = @{(NSString *)kCTFontNameAttribute : @"AppleColorEmoji"};
    appleColorEmojiFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)appleColorEmojiAttribtues);
    NSMutableCharacterSet *set = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(0, 0)];
    NSDictionary *zapfDingbatsITCAttributes = @{(NSString *)kCTFontCharacterSetAttribute : set};
    zapfDingbatsITCFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)zapfDingbatsITCAttributes);
    NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    if (systemVersion >= 9) {
        systemFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)@{(NSString *)kCTFontNameAttribute : @"PingFangSC-Regular"});
    } else {
        systemFontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)@{(NSString *)kCTFontNameAttribute : @"PingFangSC-Regular"});
    }
}

+ (instancetype)pp_fontWithCTFont:(CTFontRef)CTFont
{
    CFStringRef fontName = CTFontCopyName(CTFont, kCTFontPostScriptNameKey);
    return [UIFont fontWithName:(__bridge NSString *)fontName size:CTFontGetSize(CTFont)];
}

+ (CTFontDescriptorRef)pp_newFontDescriptorForName:(NSString *)name
{
    NSArray *fonts = @[(__bridge id)arialMTFontDescriptor,
                       (__bridge id)appleColorEmojiFontDescriptor,
                       (__bridge id)zapfDingbatsITCFontDescriptor,
                       (__bridge id)systemFontDescriptor];
    
    NSDictionary *attributes = @{(NSString *)kCTFontNameAttribute : name,
                                 (NSString *)kCTFontCascadeListAttribute : fonts};
    return CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
}

+ (CTFontRef)pp_newCTFontWithName:(NSString *)name size:(CGFloat)size
{
    @synchronized (self) {
        [self pp_createFontDescriptors];
    }
    return CTFontCreateWithFontDescriptor([self pp_newFontDescriptorForName:name], size, NULL);
}

//+ (CTFontRef)pp_newCTFontWithCTFont:(CTFontRef)CTFont symbolicTraits:(NSUInteger)symbolicTraits;
//+ (CTFontRef)pp_newItalicCTFontForCTFont:(CTFontRef)CTFont;
//+ (CTFontRef)pp_newBoldCTFontForCTFont:(CTFontRef)CTFont;
//+ (CTFontRef)pp_newBoldSystemCTFontOfSize:(CGFloat)size;
+ (CTFontRef)pp_newSystemCTFontOfSize:(CGFloat)size
{
    return CTFontCreateUIFontForLanguage(kCTFontUIFontSystem, size, NULL);
}
@end

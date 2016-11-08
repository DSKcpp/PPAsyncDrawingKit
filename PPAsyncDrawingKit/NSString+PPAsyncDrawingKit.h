//
//  NSString+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PPAsyncDrawingKit)
- (BOOL)pp_isMatchedByRegex:(NSString *)regex;
- (BOOL)pp_isMatchedByRegex:(NSString *)regex inRange:(NSRange)range;
- (BOOL)pp_isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError **)error;
- (void)pp_enumerateStringsMatchedByRegex:(NSString *)regex usingBlock:(void (^)(NSString *capturedString, NSRange capturedRange, BOOL *stop))block;
@end

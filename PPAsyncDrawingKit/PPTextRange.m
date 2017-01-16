//
//  PPTextRange.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextRange.h"

@implementation PPTextRange
//@dynamic start;
//@dynamic end;

@synthesize start = _start;
@synthesize end = _end;

- (instancetype)initWithRange:(NSRange)range
{
    PPTextPosition *start = [[PPTextPosition alloc] initWithIndex:range.location];
    PPTextPosition *end = [[PPTextPosition alloc] initWithIndex:range.location + range.length];
    return [self initWithStart:start end:end];
}

- (instancetype)initWithStart:(PPTextPosition *)start end:(PPTextPosition *)end
{
    if (self = [super init]) {
        _start = start;
        _end = end;
    }
    return self;
}

- (NSRange)range
{
    NSUInteger loc = _start.index;
    NSUInteger len = _end.index - loc;
    return NSMakeRange(loc, len);
}
@end

@implementation PPTextPosition
+ (PPTextPosition *)postionWithIndex:(NSUInteger)index
{
    return [[self alloc] initWithIndex:index];
}

- (instancetype)initWithIndex:(NSUInteger)index
{
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (int)compare:(PPTextPosition *)position
{
    NSInteger i = 0;
    if (_index != position.index) {
        i = 1;
    }
    if (_index < position.index) {
        i = -1;
    }
    return i;
}

@end

//
//  PPWeakProxy.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/8.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPWeakProxy.h"

@implementation PPWeakProxy
+ (PPWeakProxy *)weakProxyWithTarget:(id)target
{
    PPWeakProxy *obj = [[PPWeakProxy alloc] initWithTarget:target];
    return obj;
}

- (instancetype)initWithTarget:(id)target
{
    if (self) {
        _target = target;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _target;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [_target respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [_target isKindOfClass:aClass];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

@end

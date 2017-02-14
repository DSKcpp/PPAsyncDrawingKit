//
//  NSThread+PPTextRenderer.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "NSThread+PPTextRenderer.h"
#import <objc/runtime.h>
#import "PPTextLayout.h"

@implementation NSThread (PPTextRenderer)
static char threadLayoutKey;

- (PPTextLayout *)textLayout
{
    PPTextLayout *textLayout = objc_getAssociatedObject(self, &threadLayoutKey);
    if (!textLayout) {
        textLayout = [[PPTextLayout alloc] init];
        self.textLayout = textLayout;
    }
    return textLayout;
}

- (void)setTextLayout:(PPTextLayout *)textLayout
{
    objc_setAssociatedObject(self, &threadLayoutKey, textLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

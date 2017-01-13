//
//  NSThread+PPTextRenderer.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "NSThread+PPTextRenderer.h"
#import <objc/runtime.h>
#import "PPTextRenderer.h"

@implementation NSThread (PPTextRenderer)
static char threadRendererKey;

- (PPTextRenderer *)textRenderer
{
    PPTextRenderer *textRenderer = objc_getAssociatedObject(self, &threadRendererKey);
    if (!textRenderer) {
        self.textRenderer = [[PPTextRenderer alloc] init];
        return self.textRenderer;
    } else {
        return textRenderer;
    }
}

- (void)setTextRenderer:(PPTextRenderer *)textRenderer
{
    objc_setAssociatedObject(self, &threadRendererKey, textRenderer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

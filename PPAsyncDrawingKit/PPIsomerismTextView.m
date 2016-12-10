//
//  PPIsomerismTextView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPIsomerismTextView.h"

@implementation PPIsomerismTextView

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    [_textRenderers enumerateObjectsUsingBlock:^(PPTextRenderer * _Nonnull textRenderer, NSUInteger idx, BOOL * _Nonnull stop) {
        [textRenderer drawInContext:context];
    }];
    return YES;
}

- (PPTextRenderer *)rendererAtPoint:(CGPoint)point
{
    for (PPTextRenderer *textRenderer in _textRenderers) {
        if (CGRectContainsPoint(textRenderer.frame, point)) {
            return textRenderer;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = CGPointZero;
    if (touch) {
        point = [touch locationInView:self];
    }
    self.respondTextRenderer = [self rendererAtPoint:point];
    self.respondTextRenderer.eventDelegate = self;
    if (self.respondTextRenderer) {
        [self.respondTextRenderer touchesBegan:touches withEvent:event];
    }
    PPTextHighlightRange *range = self.respondTextRenderer.pressingHighlightRange;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end

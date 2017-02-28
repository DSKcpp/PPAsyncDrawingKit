//
//  PPMultiplexTextView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPMultiplexTextView.h"

@interface PPMultiplexTextView () <PPTextRendererEventDelegate>
{
    NSMutableArray<PPTextLayout *> *_internalTextLayouts;
}
@end

@implementation PPMultiplexTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _internalTextLayouts = @[].mutableCopy;
    }
    return self;
}

- (NSArray<PPTextRenderer *> *)textRenderers
{
    return [NSArray arrayWithArray:_internalTextLayouts.copy];
}

- (void)addTextLayout:(PPTextLayout *)textLayout
{
    if (!textLayout) {
        return;
    }
    textLayout.textRenderer.eventDelegate = self;
    [_internalTextLayouts addObject:textLayout];
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    [_internalTextLayouts enumerateObjectsUsingBlock:^(PPTextLayout * _Nonnull textLayout, NSUInteger idx, BOOL * _Nonnull stop) {
        [textLayout.textRenderer drawInContext:context];
    }];
    return YES;
}

- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success
{
    if (success) {
        self.hidden = NO;
    }
}


- (PPTextRenderer *)rendererAtPoint:(CGPoint)point
{
    for (PPTextLayout *textLayout in _internalTextLayouts) {
        if (CGRectContainsPoint(textLayout.frame, point)) {
            return textLayout.textRenderer;
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
    BOOL pressingRange = NO;
    _respondTextRenderer = [self rendererAtPoint:point];
    if (self.respondTextRenderer) {
        [self.respondTextRenderer touchesBegan:touches withEvent:event];
        PPTextHighlightRange *range = self.respondTextRenderer.pressingHighlightRange;
        if (range) {
            pressingRange = YES;
        }
    }
    if (!pressingRange) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BOOL pressingRange = NO;
    if (self.respondTextRenderer) {
        [self.respondTextRenderer touchesMoved:touches withEvent:event];
        PPTextHighlightRange *range = self.respondTextRenderer.pressingHighlightRange;
        if (range) {
            pressingRange = YES;
        }
    }
    if (!pressingRange) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.respondTextRenderer) {
        [self.respondTextRenderer touchesEnded:touches withEvent:event];
        _respondTextRenderer = nil;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.respondTextRenderer) {
        [self.respondTextRenderer touchesCancelled:touches withEvent:event];
        _respondTextRenderer = nil;
    }
    [super touchesCancelled:touches withEvent:event];
}

- (PPAsyncDrawingView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer
{
    return self;
}

- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    if ([_delegate respondsToSelector:@selector(textLayout:didSelectHighlightRange:)]) {
        [_delegate textLayout:textRenderer.textLayout didSelectHighlightRange:highlightRange];
    }
}

- (void)textRenderer:(PPTextRenderer *)textRenderer didPressTextBackground:(PPTextBackground *)textBackground
{
    
}

@end

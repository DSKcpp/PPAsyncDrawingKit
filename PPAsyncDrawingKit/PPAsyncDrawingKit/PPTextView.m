//
//  PPTextView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextView.h"
#import "PPTextRenderer.h"
#import <objc/runtime.h>

@interface PPTextView () <PPTextRendererEventDelegate>
{
    BOOL _needUpdateAttribtues;
}
@end

@implementation PPTextView
@synthesize textLayout = _textLayout;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    NSAttributedString *attributedString = self.attributedString;
    if (attributedString) {
        [self.textLayout.textRenderer drawInContext:context visibleRect:rect placeAttachments:YES];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textLayout.textRenderer touchesBegan:touches withEvent:event];
    if (!self.textLayout.textRenderer.pressingHighlightRange) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textLayout.textRenderer touchesMoved:touches withEvent:event];
    if (!self.textLayout.textRenderer.pressingHighlightRange) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textLayout.textRenderer touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textLayout.textRenderer touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

- (PPTextLayout *)textLayout
{
    if (!_textLayout) {
        _textLayout = [[PPTextLayout alloc] init];
        _textLayout.textRenderer.eventDelegate = self;
    }
    return _textLayout;
}

- (void)setTextLayout:(PPTextLayout *)textLayout
{
    if (_textLayout == textLayout) {
        return;
    }
    
    _textLayout = textLayout;
    _textLayout.textRenderer.eventDelegate = self;
}

- (NSAttributedString *)attributedString
{
    return self.textLayout.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    self.textLayout.attributedString = attributedString;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.attributedString) {
        return [self.attributedString pp_sizeConstrainedToSize:size numberOfLines:self.textLayout.numberOfLines];
    } else {
        return size;
    }
}

- (PPAsyncDrawingView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer
{
    return self;
}

- (void)textRenderer:(PPTextRenderer *)textRenderer pressedTextHighlightRange:(nonnull PPTextHighlightRange *)highlightRange
{
    if ([_delegate respondsToSelector:@selector(textLayout:pressedTextHighlightRange:)]) {
        [_delegate textLayout:self.textLayout pressedTextHighlightRange:highlightRange];
    }
}

- (void)textRenderer:(PPTextRenderer *)textRenderer pressedTextBackground:(nonnull PPTextBackground *)background
{
    if ([_delegate respondsToSelector:@selector(textLayout:pressedTextBackground:)]) {
        [_delegate textLayout:self.textLayout pressedTextBackground:background];
    }
}

@end

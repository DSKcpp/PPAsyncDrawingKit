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

@interface PPTextView ()
{
    BOOL _needUpdateAttribtues;
    BOOL _pendingAttachmentUpdates;
}
@end

@implementation PPTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
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

- (BOOL)pendingAttachmentUpdates
{
    return YES;
}

- (PPTextLayout *)textLayout
{
    if (!_textLayout) {
        _textLayout = [[PPTextLayout alloc] init];
        _textLayout.textRenderer.eventDelegate = self;
    }
    return _textLayout;
}

- (NSInteger)numberOfLines
{
    return self.textLayout.numberOfLines;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    self.textLayout.numberOfLines = numberOfLines;
}

- (NSAttributedString *)attributedString
{
    return self.textLayout.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    self.textLayout.attributedString = attributedString.copy;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.attributedString) {
        return [self.attributedString pp_sizeConstrainedToSize:size numberOfLines:self.numberOfLines];
    } else {
        return size;
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//}

- (PPAsyncDrawingView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer
{
    return self;
}

- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    if ([_delegate respondsToSelector:@selector(textView:didSelectTextHighlight:)]) {
        [_delegate textView:self didSelectTextHighlight:highlightRange];
    }
}

@end

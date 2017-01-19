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
        PPTextRenderer * textRenderer = [[PPTextRenderer alloc] init];
        textRenderer.eventDelegate = self;
        _textRenderer = textRenderer;
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    NSAttributedString *attributedString = self.attributedString;
    if (attributedString) {
        [self.textRenderer drawInContext:context visibleRect:rect placeAttachments:YES];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textRenderer touchesBegan:touches withEvent:event];
    if (!_textRenderer.pressingHighlightRange) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textRenderer touchesMoved:touches withEvent:event];
    if (!_textRenderer.pressingHighlightRange) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textRenderer touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textRenderer touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

- (BOOL)pendingAttachmentUpdates
{
    return YES;
}

- (PPTextLayout *)textLayout
{
    return self.textRenderer.textLayout;
}

- (NSInteger)numberOfLines
{
    return self.textRenderer.textLayout.maximumNumberOfLines;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    self.textRenderer.textLayout.maximumNumberOfLines = numberOfLines;
}

- (NSAttributedString *)attributedString
{
    return self.textRenderer.attributedString.copy;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    self.textRenderer.attributedString = attributedString.copy;
    [self setNeedsDisplayAsync];
}

- (NSInteger)lineIndexForPoint:(CGPoint)point
{
    return [self.textRenderer.textLayout lineFragmentIndexForCharacterAtIndex:[self textIndexForPoint:point]];
}

- (NSInteger)textIndexForPoint:(CGPoint)point
{
    return [self.textRenderer.textLayout characterIndexForPoint:point];
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

- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer
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

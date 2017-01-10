//
//  PPLabel.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPLabel.h"
#import "PPTextRenderer.h"
#import <objc/runtime.h>

@interface PPLabel ()
@property (nonatomic, assign) BOOL needUpdateAttribtues;
@end

@implementation PPLabel
@synthesize font = _font;
@synthesize textColor = _textColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        PPTextRenderer * textRenderer = [[PPTextRenderer alloc] init];
        textRenderer.eventDelegate = self;
        textRenderer.renderDelegate = self;
        _textRenderer = textRenderer;
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width
{
    return [self initWithFrame:CGRectMake(0, 0, width, 0)];
}

- (NSDictionary *)currentDrawingUserInfo
{
    if (self.attributedString) {
        return @{@"attributedString" : self.attributedString};
    } else {
        return nil;
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(NSDictionary *)userInfo
{
    NSAttributedString *attributedString = userInfo[@"attributedString"];
    if (attributedString) {
        [self _updateTextRendererWithAttributedString:attributedString];
//        self.pendingAttachmentUpdates
        [self.textRenderer drawInContext:context visibleRect:rect placeAttachments:YES shouldInterruptBlock:nil];
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

- (void)setText:(NSString *)text
{
    if (_text != text) {
        _text = text;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
        [self _updateTextRendererWithAttributedString:attributedString];
        [self setNeedsDisplayAsync];
        self.pendingAttachmentUpdates = YES;
    }
}

- (UIFont *)font
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:15.0f];
    }
    return _font;
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        _needUpdateAttribtues = YES;
    }
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor) {
        _textColor = textColor;
        _needUpdateAttribtues = YES;
    }
}

- (void)_updateTextRendererWithAttributedString:(NSAttributedString *)attributedString
{
    if (self.textRenderer.attributedString != attributedString) {
        if (_needUpdateAttribtues) {
            NSMutableAttributedString *attrStrM = (NSMutableAttributedString *)attributedString;
            [attrStrM pp_setFont:self.font];
            [attrStrM pp_setColor:self.textColor];
            _needUpdateAttribtues = NO;
        }
        self.textRenderer.attributedString = attributedString;
    }
}

- (void)_updateTextRendererWithCurrentAttributedString
{
    [self _updateTextRendererWithAttributedString:self.attributedString];
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
    
}

@end


//
//  PPTextRenderer.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextRenderer.h"
#import "PPTextLayoutLine.h"
#import "PPTextAttachment.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"

struct PPTextRendererEventDelegateHas {
    BOOL didPressHighlightRange;
    BOOL contextViewForTextRenderer;
    BOOL shouldInteractWithHighlightRange;
};
typedef struct PPTextRendererEventDelegateHas PPTextRendererEventDelegateHas;

@interface PPTextRenderer ()
{
    CGPoint _touchesBeginPoint;
    PPTextRendererEventDelegateHas _eventDelegateHas;
}
@end

@implementation PPTextRenderer

#pragma mark - Draw
- (void)draw
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    [self drawInContext:context visibleRect:CGRectNull placeAttachments:YES];
}

- (void)drawInContext:(CGContextRef)context visibleRect:(CGRect)visibleRect placeAttachments:(BOOL)placeAttachments
{
    if (context) {
        NSAttributedString *attributedString = self.attributedString;
        if (attributedString.length > 0) {
            if (!CGRectIsNull(visibleRect)) {
                self.textLayout.size = visibleRect.size;
            }
            PPTextLayoutFrame *layoutFrame = self.textLayout.layoutFrame;
            if (layoutFrame) {
                UIOffset offset = [self drawingOffsetWithTextLayout:self.textLayout layoutFrame:layoutFrame];
                if ([PPTextRenderer debugModeEnabled]) {
                    [self debugModeDrawLineFramesWithLayoutFrame:layoutFrame context:context offset:offset];
                }
                PPTextHighlightRange *highlightRange = self.pressingHighlightRange;
                if (highlightRange) {
                    [self enumerateEnclosingRectsForCharacterRange:highlightRange.range usingBlock:^(CGRect rect, BOOL *stop) {
                        [self drawHighlightedBackgroundForHighlightRange:highlightRange rect:rect context:context];
                    }];
                }
            }
            CGContextSaveGState(context);
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -self.textLayout.size.height);
            for (PPTextLayoutLine *line in self.textLayout.layoutFrame.lineFragments) {
                CGPoint position = [self.textLayout convertPointToCoreText:line.baselineOrigin];
                CGFloat y = -self.drawingOrigin.y + position.y;
                CGFloat x = self.drawingOrigin.x + position.x;
                CGContextSetTextPosition(context, x, y);
                CTLineDraw(line.lineRef, context);
            }
            CGContextRestoreGState(context);
            if (placeAttachments) {
                [self drawAttachmentsWithAttributedString:attributedString layoutFrame:self.textLayout.layoutFrame context:context];
            }
        }
    }
}

- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString layoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context
{
    [layoutFrame.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        [line enumerateLayoutRunsUsingBlock:^(NSDictionary *attributes, NSRange range) {
            PPTextAttachment *textAttachment = [attributes objectForKey:PPTextAttachmentAttributeName];
            if (textAttachment) {
                CGPoint origin = [line baselineOriginForCharacterAtIndex:range.location];
                CGSize size = textAttachment.contentSize;
                CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
                UIEdgeInsets edgeInsets = textAttachment.contentEdgeInsets;
//                rect = UIEdgeInsetsInsetRect(rect, edgeInsets);
                PPTextFontMetrics *font = textAttachment.fontMetricsForLayout;
                rect.origin.y -= font.ascent;
                UIImage *image = textAttachment.contents;
                if (image) {
                    rect = [self convertRectFromLayout:rect];
                    UIGraphicsPushContext(context);
                    [image drawInRect:rect];
                    UIGraphicsPopContext();
                }
            }
        }];
    }];
}

- (void)drawHighlightedBackgroundForHighlightRange:(PPTextHighlightRange *)highlightRange rect:(CGRect)rect context:(CGContextRef)context
{
    PPTextBorder *textBorder = highlightRange.attributes[PPTextBorderAttributeName];
    if (textBorder) {
        CGColorRef color;
        if (textBorder.fillColor) {
            color = textBorder.fillColor.CGColor;
        } else {
            color = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
        }
        CGContextSetFillColorWithColor(context, color);
        CGContextBeginPath(context);
        CGFloat x = rect.origin.x;
        CGFloat y = rect.origin.y;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        CGFloat radius = 5.0f;
        CGContextMoveToPoint(context, x + radius, y);
        x += width;
        CGContextAddLineToPoint(context, x + width - radius, y);
        CGContextAddArc(context, x - radius, y + radius, radius,  -0.5 * M_PI, 0.0f, 0);
        y += height;
        CGContextAddLineToPoint(context, x, y);
        CGContextAddArc(context, x - radius, y - radius, radius, 0, 0.5 * M_PI, 0);
        x -= width;
        CGContextAddLineToPoint(context, x + radius, y);
        CGContextAddArc(context, x + radius, y - radius, radius, 0.5 * M_PI, M_PI, 0);
        y -= height;
        CGContextAddLineToPoint(context, x, y);
        CGContextAddArc(context, x + radius, y + radius, radius, M_PI, 1.5 * M_PI, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(id)arg2
{
    return UIOffsetZero;
}

#pragma mark - Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *touchView = self.eventDelegateContextView;
    if (touchView) {
        NSSet<UITouch *> * _touches = [event touchesForView:touchView];
        UITouch *touch = _touches.anyObject;
        CGPoint point = CGPointZero;
        if (touch) {
            point = [touch locationInView:touchView];
        }
        point = [self convertPointToLayout:point];
        PPTextHighlightRange *range = [self highlightRangeForLayoutLocation:point];
        if (range) {
            self.pressingHighlightRange = range;
            [touchView setNeedsDisplay];
        }
        _touchesBeginPoint = point;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *touchView = self.eventDelegateContextView;
    UITouch *touch = touches.anyObject;
    CGPoint point = CGPointZero;
    if (touch) {
        point = [touch locationInView:touchView];
    }
    CGPoint touchesBeginPoint = _touchesBeginPoint;
//    if (point.x > touchesBeginPoint.x) {
//        
//    }
    if (_pressingHighlightRange) {
        _savedPressingHighlightRange = _pressingHighlightRange;
        [touchView setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _savedPressingHighlightRange = nil;
    PPTextHighlightRange *high = self.pressingHighlightRange;
    if (high) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self eventDelegateDidPressHighlightRange:high];
        });
        self.pressingHighlightRange = nil;
        UIView *touchView = self.eventDelegateContextView;
        [touchView setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _savedPressingHighlightRange = nil;
    if (_pressingHighlightRange) {
        _pressingHighlightRange = nil;
        [self.eventDelegateContextView setNeedsDisplay];
    }
}

#pragma mark - getter & setter
- (PPTextLayout *)textLayout
{
    if (!_textLayout) {
        _textLayout = [[PPTextLayout alloc] init];
    }
    return _textLayout;
}

- (NSAttributedString *)attributedString
{
    return self.textLayout.attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    self.textLayout.attributedString = attributedString;
}

- (void)setEventDelegate:(id<PPTextRendererEventDelegate>)eventDelegate
{
    _eventDelegate = eventDelegate;
    _eventDelegateHas.contextViewForTextRenderer = [eventDelegate respondsToSelector:@selector(contextViewForTextRenderer:)];
    _eventDelegateHas.didPressHighlightRange = [eventDelegate respondsToSelector:@selector(textRenderer:didPressHighlightRange:)];
    _eventDelegateHas.shouldInteractWithHighlightRange = [eventDelegate respondsToSelector:@selector(textRenderer:shouldInteractWithHighlightRange:)];
}

#pragma mark - Layout
- (CGRect)frame
{
    CGSize size;
    if (self.textLayout) {
        size = self.textLayout.size;
    } else {
        size = CGSizeZero;
    }
    return (CGRect){self.drawingOrigin, size};
}

- (void)setFrame:(CGRect)frame
{
    self.drawingOrigin = frame.origin;
    self.textLayout.size = frame.size;
}

@end

@implementation PPTextRenderer (LayoutResult)
- (CGSize)layoutSize
{
    return self.textLayout.layoutSize;
}

- (CGFloat)layoutHeight
{
    return self.textLayout.layoutHeight;
}

- (NSUInteger)layoutLineCount
{
    return self.textLayout.containingLineCount;
}

- (NSRange)layoutStringRange
{
    return [self.textLayout containingStringRange];
}

- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index
{
    return [self.textLayout locationForCharacterAtIndex:index];
}

- (NSUInteger)characterIndexForPoint:(CGPoint)point
{
    return [self.textLayout characterIndexForPoint:point];
}

- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)effectiveRange
{
    return [self.textLayout lineFragmentRectForLineAtIndex:index effectiveRange:effectiveRange];
}

- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index
{
    return [self.textLayout lineFragmentIndexForCharacterAtIndex:index];
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    return [self.textLayout boundingRectForCharacterRange:range];
}

- (NSRange)characterRangeForBoundingRect:(CGRect)rect
{
    return [self.textLayout characterRangeForBoundingRect:rect];
}

- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)effectiveRange
{
    return [self.textLayout lineFragmentRectForCharacterAtIndex:index effectiveRange:effectiveRange];
}

- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range
{
    return [self.textLayout firstSelectionRectForCharacterRange:range];
}

- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(nullable void (^)(CGRect, BOOL * _Nonnull))block
{
    return [self.textLayout enumerateSelectionRectsForCharacterRange:range usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
        if (block) block([self convertRectFromLayout:rect], stop);
    }];
}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, NSRange, BOOL * _Nonnull))block
{
    [self.textLayout enumerateLineFragmentsForCharacterRange:range usingBlock:^(CGRect rect, NSRange range, BOOL * _Nonnull stop) {
        if (block) block([self convertRectFromLayout:rect], range, stop);
    }];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(void (^)(CGRect , BOOL *))block
{
    [self.textLayout enumerateEnclosingRectsForCharacterRange:range usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
        if (block) block([self convertRectFromLayout:rect], stop);
    }];
}

@end

@implementation PPTextRenderer (Coordinates)
- (CGPoint)convertPointToLayout:(CGPoint)point
{
    CGPoint drawingOrigin = self.drawingOrigin;
    return CGPointMake(point.x - drawingOrigin.x, point.y - drawingOrigin.y);
}

- (CGPoint)convertPointFromLayout:(CGPoint)point
{
    CGPoint drawingOrigin = self.drawingOrigin;
    return CGPointMake(point.x + drawingOrigin.x, point.y + drawingOrigin.y);
}

- (CGRect)convertRectToLayout:(CGRect)rect
{
    if (CGRectIsNull(rect)) {
        
    } else {
        rect.origin = [self convertPointToLayout:rect.origin];
    }
    return rect;
}

- (CGRect)convertRectFromLayout:(CGRect)rect
{
    if (CGRectIsNull(rect)) {
        
    } else {
        rect.origin = [self convertPointFromLayout:rect.origin];
    }
    return rect;
}

@end

@implementation PPTextRenderer (Events)
- (UIView *)eventDelegateContextView
{
    if (_eventDelegateHas.contextViewForTextRenderer) {
        return [_eventDelegate contextViewForTextRenderer:self];
    }
    return nil;
}

- (void)eventDelegateDidPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    if (_eventDelegateHas.didPressHighlightRange) {
        [_eventDelegate textRenderer:self didPressHighlightRange:highlightRange];
    }
}

- (PPTextHighlightRange *)highlightRangeForLayoutLocation:(CGPoint)location
{
    __block PPTextHighlightRange *r;
    __weak typeof(self) weakSelf = self;
    [self.attributedString enumerateAttribute:PPTextHighlightRangeAttributeName inRange:[self.attributedString pp_stringRange] options:kNilOptions usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            [weakSelf.textLayout enumerateEnclosingRectsForCharacterRange:range usingBlock:^(CGRect rect, BOOL * _Nonnull sstop) {
                if (CGRectContainsPoint(rect, location)) {
                    r = value;
                    r.range = range;
                    *sstop = YES;
                    *stop = YES;
                }
            }];
        }
    }];
    return r;
}

@end

@implementation PPTextRenderer (Debug)
static BOOL textRendererDebugModeEnabled = NO;
+ (BOOL)debugModeEnabled
{
    return textRendererDebugModeEnabled;
}

+ (void)enableDebugMode
{
    [self setDebugModeEnabled:YES];
}

+ (void)disableDebugMode
{
    [self setDebugModeEnabled:NO];
}

+ (void)setDebugModeEnabled:(BOOL)enabled
{
    textRendererDebugModeEnabled = enabled;
}

- (void)debugModeDrawLineFramesWithLayoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context offset:(UIOffset)offset
{
    CGPoint origin = self.drawingOrigin;
    CGSize size = self.textLayout.size;
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 0.1f);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, CGRectMake(origin.x, origin.y, size.width, size.height));
    CGContextRestoreGState(context);
    
    [layoutFrame.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [self convertRectFromLayout:line.fragmentRect];
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 0.1f);
        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        rect.origin.y -= line.lineMetrics.ascent;
        CGContextFillRect(context, rect);
        
        CGContextSetAlpha(context, 1.0f);
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillRect(context, CGRectMake(line.baselineOrigin.x + origin.x, line.baselineOrigin.y + origin.y, rect.size.width, 0.5f));
        CGContextRestoreGState(context);
    }];
    
}

@end


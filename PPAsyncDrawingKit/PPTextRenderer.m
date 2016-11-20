
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

@implementation PPTextRenderer
- (instancetype)init
{
    if (self = [super init]) {
        self.heightSensitiveLayout = YES;
    }
    return self;
}

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

- (void)draw
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    [self drawInContext:context shouldInterruptBlock:nil];
}

- (void)drawInContext:(CGContextRef)context shouldInterruptBlock:(void (^)(void))shouldInterruptBlock
{
    [self drawInContext:context visibleRect:CGRectNull placeAttachments:YES shouldInterruptBlock:shouldInterruptBlock];
}

- (void)drawInContext:(CGContextRef)context visibleRect:(CGRect)visibleRect placeAttachments:(BOOL)placeAttachments shouldInterruptBlock:(void (^)(void))shouldInterruptBlock
{
    if (context) {
        NSAttributedString *attributedString = self.attributedString;
        if (attributedString) {
            PPTextLayoutFrame *layoutFrame = self.textLayout.layoutFrame;
            if (layoutFrame) {
                UIOffset offset = [self drawingOffsetWithTextLayout:self.textLayout layoutFrame:layoutFrame];
//                NSRange range = self.pressingActiveRange.range;
//                [self enumerateEnclosingRectsForCharacterRange:range usingBlock:^{
//                    
//                }];
            }
            CGContextSaveGState(context);
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextTranslateCTM(context, self.drawingOrigin.x, self.drawingOrigin.y + self.textLayout.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            for (PPTextLayoutLine *line in self.textLayout.layoutFrame.lineFragments) {
                CGPoint position = line.originalBaselineOrigin;
                CGContextSetTextPosition(context, position.x, position.y);
                CTLineDraw(line.lineRef, context);
            }
            CGContextRestoreGState(context);
            if (placeAttachments) {
                [self drawAttachmentsWithAttributedString:attributedString layoutFrame:self.textLayout.layoutFrame context:context shouldInterrupt:shouldInterruptBlock];
            }
        }
    }
}

- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString layoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context shouldInterrupt:(void (^)(void))shouldInterruptBlock
{
    CGFloat scale = [UIScreen mainScreen].scale;
    [layoutFrame.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        [line enumerateLayoutRunsUsingBlock:^(NSDictionary *attributes, NSRange range) {
            PPTextAttachment *textAttachment = [attributes objectForKey:@"PPTextAttachmentAttributeName"];
            if ([textAttachment isKindOfClass:[PPTextAttachment class]]) {
                
            } else {
                
            }
        }];
    }];
//    shouldInterruptBlock();
}

- (void)drawHighlightedBackgroundForActiveRange:(id)arg1 rect:(CGRect)rect context:(CGContextRef)context
{
    rect = CGRectIntegral(rect);
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:1.0];
    [color set];
    CGContextSetShadowWithColor(context, rect.size, 1.0, color.CGColor);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>)
//    CGContextAddLineToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>)
//    CGContextAddArc(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#int clockwise#>)
//    CGContextAddLineToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>)
//    CGContextAddArc(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#int clockwise#>)
//    CGContextAddLineToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>)
//    CGContextAddArc(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#int clockwise#>)
//    CGContextClosePath(context);
}

- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(id)arg2
{
    return UIOffsetZero;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.eventDelegateContextView) {
        NSSet<UITouch *> * _touches = [event touchesForView:self.eventDelegateContextView];
        UITouch *touch = _touches.anyObject;
        CGPoint point;
        if (touch) {
            point = [touch locationInView:self.eventDelegateContextView];
        } else {
            point = CGPointZero;
        }
        point = [self convertPointToLayout:point];
        [self rangeInRanges:[self eventDelegateActiveRanges] forLayoutLocation:point];   
    }
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
    if (self.textLayout) {
        self.textLayout.size = frame.size;
    } else {
        
    }
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
    [self debugModeSetEverythingNeedsDisplay];
    [CATransaction flush];
}

+ (void)debugModeSetEverythingNeedsDisplay
{
    
}

+ (void)debugModeSetEverythingNeedsDisplayForView:(id)view
{
    
}

- (void)debugModeDrawLineFramesWithLayoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context offset:(UIOffset)offset
{
    if (self.textLayout) {
        
    } else {
        
    }
}

@end

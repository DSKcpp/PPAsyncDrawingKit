//
//  PPCoreTextInternalView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPCoreTextInternalView.h"
#import "PPTextRenderer.h"
#import <objc/runtime.h>

@implementation PPCoreTextInternalView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame textRendererClass:[PPTextRenderer class]];
}

- (instancetype)initWithFrame:(CGRect)frame textRendererClass:(Class)class
{
    if ([class isSubclassOfClass:[PPTextRenderer class]]) {
        
    } else {
        
    }
    if (self = [super initWithFrame:frame]) {
        PPTextRenderer * textRenderer = [[class alloc] init];
        self.textRenderer = textRenderer;
        textRenderer.eventDelegate = self;
        textRenderer.renderDelegate = self;
        self.drawingPolicy = 1;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        _attributedString = attributedString;
        [self _updateTextRendererWithAttributedString:attributedString];
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsDisplay];
        self.pendingAttachmentUpdates = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PPCoreTextInternalViewAttributedStringDidUpdateNotification" object:self];
    }
}

- (void)_updateTextRendererWithAttributedString:(NSAttributedString *)attributedString
{
    if (self.textRenderer.attributedString != attributedString) {
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
    return [super sizeThatFits:size];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)dealloc
{
    self.textRenderer = nil;
    self.attributedString = nil;
}
@end

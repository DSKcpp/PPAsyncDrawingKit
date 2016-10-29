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
        [self setBackgroundColor:[UIColor clearColor]];
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
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
        [self.textRenderer drawInContext:context visibleRect:rect placeAttachments:YES shouldInterruptBlock:^{
            
        }];
    }
    return YES;
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
    if (self.attributedString) {
        return [self.attributedString pp_sizeConstrainedToSize:size numberOfLines:self.numberOfLines];
    } else {
        return CGSizeZero;
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//}

- (void)dealloc
{
    self.textRenderer = nil;
    self.attributedString = nil;
}
@end

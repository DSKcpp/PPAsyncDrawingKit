//
//  PPCoreTextInternalView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "PPTextRenderer.h"


@class PPTextLayout;

@interface PPCoreTextInternalView : PPAsyncDrawingView <PPTextRendererDelegate, PPTextRendererEventDelegate>
@property (nonatomic, assign) BOOL pendingAttachmentUpdates;
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nonatomic, strong) PPTextRenderer *textRenderer;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) NSRange visibleStringRange;
@property (nonatomic, assign) NSInteger numberOfLines;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame textRendererClass:(Class)class;

- (void)textRenderer:(PPTextRenderer *)textRenderer placeAttachment:(id)arg2 frame:(CGRect)frame context:(CGContextRef)context;
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressActiveRange:(id)arg2;
- (id)activeRangesForTextRenderer:(PPTextRenderer *)textRenderer;
- (id)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

- (NSInteger)lineIndexForPoint:(CGPoint)point;
- (NSInteger)textIndexForPoint:(CGPoint)point;
@end

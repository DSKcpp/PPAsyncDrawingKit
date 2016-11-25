//
//  PPLabel.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "PPTextRenderer.h"

@class PPTextLayout;
@class PPAttributedText;

NS_ASSUME_NONNULL_BEGIN

@interface PPLabel : PPAsyncDrawingView <PPTextRendererDelegate, PPTextRendererEventDelegate>
@property (nonatomic, assign) BOOL pendingAttachmentUpdates;
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nonatomic, strong) PPTextRenderer *textRenderer;
@property (nonatomic, assign) NSRange visibleStringRange;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, strong, readonly) NSAttributedString *attributedString;
@property (nonatomic, strong) PPAttributedText *text;

- (instancetype)initWithWidth:(CGFloat)width;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)textRenderer:(PPTextRenderer *)textRenderer placeAttachment:(id)arg2 frame:(CGRect)frame context:(CGContextRef)context;

- (NSInteger)lineIndexForPoint:(CGPoint)point;
- (NSInteger)textIndexForPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END

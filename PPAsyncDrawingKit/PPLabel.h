//
//  PPLabel.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "PPTextRenderer.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"

@class PPTextLayout;

NS_ASSUME_NONNULL_BEGIN

@interface PPLabel : PPAsyncDrawingView <PPTextRendererDelegate, PPTextRendererEventDelegate>
@property (nonatomic, assign) BOOL pendingAttachmentUpdates;
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nullable, nonatomic, copy) NSString *text;
@property (null_resettable, nonatomic, strong) UIFont *font;
@property (null_resettable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nullable, nonatomic, strong) PPTextRenderer *textRenderer;
@property (nonatomic, assign) NSRange visibleStringRange;
@property (nonatomic, assign) NSInteger numberOfLines;

- (instancetype)initWithWidth:(CGFloat)width;
- (instancetype)initWithFrame:(CGRect)frame;

- (NSInteger)lineIndexForPoint:(CGPoint)point;
- (NSInteger)textIndexForPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END

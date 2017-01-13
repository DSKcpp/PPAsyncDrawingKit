//
//  PPTextView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPAsyncDrawingView.h>
#import <PPAsyncDrawingKit/PPTextRenderer.h>
#import <PPAsyncDrawingKit/NSAttributedString+PPAsyncDrawingKit.h>

@class PPTextLayout;

NS_ASSUME_NONNULL_BEGIN

@interface PPTextView : PPAsyncDrawingView <PPTextRendererDelegate, PPTextRendererEventDelegate>
@property (nonatomic, strong, readonly) PPTextLayout *textLayout;
@property (nonatomic, strong, readonly) PPTextRenderer *textRenderer;
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, assign) NSInteger numberOfLines;

- (instancetype)initWithWidth:(CGFloat)width;
- (instancetype)initWithFrame:(CGRect)frame;

- (NSInteger)lineIndexForPoint:(CGPoint)point;
- (NSInteger)textIndexForPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END

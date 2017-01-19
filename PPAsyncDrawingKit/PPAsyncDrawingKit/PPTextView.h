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
@class PPTextHighlightRange;
@class PPTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextViewDelegate <NSObject>

@optional

- (void)textView:(PPTextView *)textView didSelectTextHighlight:(PPTextHighlightRange *)textHighlight;
@end

@interface PPTextView : PPAsyncDrawingView <PPTextRendererEventDelegate>
@property (nonatomic, strong, readonly) PPTextLayout *textLayout;
@property (nonatomic, strong, readonly) PPTextRenderer *textRenderer;
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nullable, nonatomic, weak) id<PPTextViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (NSInteger)lineIndexForPoint:(CGPoint)point;
- (NSInteger)textIndexForPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END

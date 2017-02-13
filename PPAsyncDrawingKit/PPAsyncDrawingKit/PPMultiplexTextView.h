//
//  PPMultiplexTextView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPAsyncDrawingView.h>
#import <PPAsyncDrawingKit/PPTextLayout.h>

NS_ASSUME_NONNULL_BEGIN

/**
 根据 PPTextLayout 的frame，一次性渲染多个 AttributedString 到 View 上
 */
@interface PPMultiplexTextView : PPAsyncDrawingView <PPTextRendererEventDelegate>

/**
 当前的 textLayouts
 */
@property (nullable, nonatomic, strong, readonly) NSArray<PPTextLayout *> *textLayouts;

/**
 当前选中的 PPTextLayout 的 TextRenderer
 */
@property (nullable, nonatomic, strong, readonly) PPTextRenderer *respondTextRenderer;

/**
 添加 PPTextLayout 到 View 上

 @param textLayout PPTextLayout
 */
- (void)addTextLayout:(PPTextLayout *)textLayout;

- (nullable PPTextRenderer *)rendererAtPoint:(CGPoint)point;
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

NS_ASSUME_NONNULL_END

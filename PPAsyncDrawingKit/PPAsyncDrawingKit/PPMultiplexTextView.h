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

@interface PPMultiplexTextView : PPAsyncDrawingView <PPTextRendererEventDelegate>

@property (nullable, nonatomic, strong, readonly) NSArray<PPTextLayout *> *textLayouts;
@property (nullable, nonatomic, strong, readonly) PPTextRenderer *respondTextRenderer;

- (void)addTextLayout:(PPTextLayout *)textLayout;

- (nullable PPTextRenderer *)rendererAtPoint:(CGPoint)point;
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

NS_ASSUME_NONNULL_END

//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PPAsyncDrawingKit/PPTextAttributes.h>

@class PPAsyncDrawingView;
@class PPTextLayoutFrame;
@class PPTextAttachment;
@class PPTextRenderer;
@class PPTextLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextRendererEventDelegate <NSObject>
- (PPAsyncDrawingView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

@optional
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressTextBackground:(PPTextBackground *)textBackground;
@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, weak) PPTextLayout *textLayout;
@property (nullable, nonatomic, strong) PPTextHighlightRange *pressingHighlightRange;
@property (nonatomic, assign) BOOL highlight;
@property (nullable, nonatomic, weak) id<PPTextRendererEventDelegate> eventDelegate;

+ (PPTextRenderer *)textRendererWithTextLayout:(PPTextLayout *)textLayout;
- (instancetype)initWithTextLayout:(PPTextLayout *)textLayout;
@end

@interface PPTextRenderer (PPTextRendererDrawing)

/**
 绘制
 
 @param context 绘制所需的 context
 */
- (void)drawInContext:(CGContextRef)context;

/**
 绘制

 @param context 绘制所需的 context
 @param visibleRect 绘制所需的 rect，如果是 CGRectNull，根据当前的 layout 的 frame 进行绘制
 @param placeAttachments 是否需要绘制 attachment
 */
- (void)drawInContext:(CGContextRef)context
          visibleRect:(CGRect)visibleRect
     placeAttachments:(BOOL)placeAttachments;

/**
 绘制 attachment，如果 placeAttachments 是 YES 的话，自动调用

 @param attributedString 绘制所需的 attribtued string
 @param layoutFrame 绘制所需的 layout frame
 @param context 绘制所需的 context
 */
- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString
                                layoutFrame:(PPTextLayoutFrame *)layoutFrame
                                    context:(CGContextRef)context;

/**
 绘制高亮

 @param highlightRange 绘制所需的 highlightRange
 @param rect 绘制所需的 rect
 @param context 绘制所需的 context
 */
- (void)drawBorder:(PPTextHighlightRange *)highlightRange
              rect:(CGRect)rect
           context:(CGContextRef)context;

/**
 绘制背景

 @param textBackground 背景
 @param context 绘制所需的 context
 */
- (void)drawTextBackground:(PPTextBackground *)textBackground context:(CGContextRef)context;
@end

@interface PPTextRenderer (PPTextRendererEvents)
- (nullable PPAsyncDrawingView *)eventDelegateContextView;
- (nullable PPTextHighlightRange *)highlightRangeForLayoutLocation:(CGPoint)location;
- (void)eventDelegateDidPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (void)eventDelegateDidPressTextBackground:(PPTextBackground *)textBackground;
@end

@interface PPTextRenderer (PPTextRendererPreviewing)
- (id)activeRangeAtLocation:(CGPoint)location;
@end

@interface PPTextRenderer (PPTextRendererCoordinates)
- (CGRect)convertRectToLayout:(CGRect)rect;
- (CGRect)convertRectFromLayout:(CGRect)rect;
- (CGPoint)convertPointToLayout:(CGPoint)point;
- (CGPoint)convertPointFromLayout:(CGPoint)point;
@end

@interface PPTextRenderer (PPTextRendererDebug)

/**
 开启 DEBUG 模式，默认关闭，高亮显示 draw frame / baseline / line
 */
@property (nonatomic, class, assign) BOOL debugModeEnabled;

/**
 如果开启 DEBUG 模式将会自动调用这个方法进行高亮绘制

 @param layoutFrame 需要高亮绘制的 layoutFrame
 @param context 需要高亮绘制的 context
 */
- (void)drawdebugMode:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context;
@end

NS_ASSUME_NONNULL_END

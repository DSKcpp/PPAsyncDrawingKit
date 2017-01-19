//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PPAsyncDrawingKit/PPTextLayout.h>
#import <PPAsyncDrawingKit/PPTextAttributes.h>

@class PPTextLayoutFrame;
@class PPTextAttachment;
@class PPTextRenderer;

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextRendererEventDelegate <NSObject>
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

@optional
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nullable, nonatomic, strong) PPTextHighlightRange *savedPressingHighlightRange;
@property (nullable, nonatomic, strong) PPTextHighlightRange *pressingHighlightRange;
@property (nullable, nonatomic, weak) id<PPTextRendererEventDelegate> eventDelegate;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGPoint drawingOrigin;

@end

@interface PPTextRenderer (PPTextRendererDrawing)
/**
 draw current context
 */
- (void)draw;

/**
 draw context
 
 @param context the context
 */
- (void)drawInContext:(CGContextRef)context;

- (void)drawInContext:(CGContextRef)context
          visibleRect:(CGRect)visibleRect
     placeAttachments:(BOOL)placeAttachments;

- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString
                                layoutFrame:(PPTextLayoutFrame *)layoutFrame
                                    context:(CGContextRef)context;

- (void)drawHighlightedBackgroundForHighlightRange:(PPTextHighlightRange *)highlightRange
                                              rect:(CGRect)rect context:(CGContextRef)context;
@end

@interface PPTextRenderer (PPTextRendererEvents)
- (nullable PPTextHighlightRange *)highlightRangeForLayoutLocation:(CGPoint)location;
- (void)eventDelegateDidPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (nullable UIView *)eventDelegateContextView;
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

@interface PPTextRenderer (PPTextRendererLayoutResult)
@property (nonatomic, assign, readonly) CGFloat layoutHeight;
@property (nonatomic, assign, readonly) CGSize layoutSize;
@property (nonatomic, assign, readonly) NSUInteger layoutLineCount;
@property (nonatomic, assign, readonly) NSRange layoutStringRange;

- (NSUInteger)characterIndexForPoint:(CGPoint)point;
- (NSRange)characterRangeForBoundingRect:(CGRect)rect;
- (CGRect)boundingRectForCharacterRange:(NSRange)range;
- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index;
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(nullable void(^)(CGRect rect, BOOL *stop))block;
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(CGRect rect, BOOL *stop))block;
- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void(^)(CGRect rect, NSRange range, BOOL *stop))block;
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range;
- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)index effectiveRange:(nullable NSRangePointer)effectiveRange;
- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)index effectiveRange:(nullable NSRangePointer)effectiveRange;
- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index;
@end

@interface PPTextRenderer (PPTextRendererDebug)
@property (nonatomic, class, assign) BOOL debugModeEnabled;
- (void)debugModeDrawLineFramesWithLayoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context;
@end

NS_ASSUME_NONNULL_END

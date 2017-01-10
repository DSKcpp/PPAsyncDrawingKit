//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextLayout.h"
#import "PPTextAttributes.h"

@class PPTextLayoutFrame;
@class PPTextAttachment;
@class PPTextRenderer;

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextRendererDelegate <NSObject>
@optional
- (void)textRenderer:(PPTextRenderer *)textRenderer
     placeAttachment:(PPTextAttachment *)attachment
               frame:(CGRect)frame
             context:(CGContextRef)context;
@end

@protocol PPTextRendererEventDelegate <NSObject>
- (void)textRenderer:(PPTextRenderer *)textRenderer didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

@optional
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nullable, nonatomic, weak) id<PPTextRendererDelegate> renderDelegate;
@property (nullable, nonatomic, weak) id<PPTextLayoutDelegate> layoutDelegate;
@property (nullable, nonatomic, strong) PPTextHighlightRange *savedPressingHighlightRange;
@property (nullable, nonatomic, strong) PPTextHighlightRange *pressingHighlightRange;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGPoint drawingOrigin;

- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(PPTextLayoutFrame *)layoutFrame;

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

#pragma mark - Events
@property (nullable, nonatomic, weak) id<PPTextRendererEventDelegate> eventDelegate;
@end

@interface PPTextRenderer (Events)
- (nullable PPTextHighlightRange *)highlightRangeForLayoutLocation:(CGPoint)location;
- (void)eventDelegateDidPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (nullable UIView *)eventDelegateContextView;
@end

@interface PPTextRenderer (Previewing)
- (id)activeRangeAtLocation:(CGPoint)location;
@end

@interface PPTextRenderer (Coordinates)
- (CGRect)convertRectToLayout:(CGRect)rect;
- (CGRect)convertRectFromLayout:(CGRect)rect;
- (CGPoint)convertPointToLayout:(CGPoint)point;
- (CGPoint)convertPointFromLayout:(CGPoint)point;
@end

@interface PPTextRenderer (LayoutResult)
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
- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range;
- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)index effectiveRange:(nullable NSRangePointer)effectiveRange;
- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)index effectiveRange:(nullable NSRangePointer)effectiveRange;
- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index;
@end

@interface PPTextRenderer (Debug)
+ (BOOL)debugModeEnabled;
+ (void)disableDebugMode;
+ (void)enableDebugMode;
+ (void)setDebugModeEnabled:(BOOL)enabled;
- (void)debugModeDrawLineFramesWithLayoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context offset:(UIOffset)offset;
@end

NS_ASSUME_NONNULL_END

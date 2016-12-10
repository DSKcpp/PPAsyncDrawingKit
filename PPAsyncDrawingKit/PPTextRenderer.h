//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextLayout.h"
#import "PPTextActiveRange.h"
#import "PPTextHighlightRange.h"

@class PPTextLayoutFrame;
@class PPTextAttachment;

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
- (NSArray<PPTextHighlightRange *> *)highlightRangesForTextRenderer:(PPTextRenderer *)textRenderer;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

@optional
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) BOOL heightSensitiveLayout;
@property (nullable, nonatomic, weak) id <PPTextRendererDelegate> renderDelegate;
@property (nullable, nonatomic, weak) id <PPTextLayoutDelegate> layoutDelegate;
@property (nullable, nonatomic, strong) PPTextActiveRange *savedPressingActiveRange;
@property (nullable, nonatomic, strong) PPTextHighlightRange *pressingHighlightRange;
@property (nonatomic, assign) CGPoint drawingOrigin;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) UIOffset shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) PPTextLayout *textLayout;
- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(PPTextLayoutFrame *)layoutFrame;
- (void)drawHighlightedBackgroundForActiveRange:(PPTextActiveRange *)activeRange rect:(CGRect)rect context:(CGContextRef)context;
- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString
                                layoutFrame:(PPTextLayoutFrame *)layoutFrame
                                    context:(CGContextRef)context
                            shouldInterrupt:(nullable void(^)(BOOL *stop))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context
          visibleRect:(CGRect)visibleRect
     placeAttachments:(BOOL)placeAttachments
 shouldInterruptBlock:(nullable void(^)(BOOL *stop))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context shouldInterruptBlock:(nullable void(^)(BOOL *stop))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context;
- (void)draw;

#pragma mark - LayoutResult
- (NSUInteger)characterIndexForPoint:(CGPoint)point;
- (NSRange)characterRangeForBoundingRect:(CGRect)rect;
- (CGRect)boundingRectForCharacterRange:(NSRange)range;
- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index;
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(CGRect rect, BOOL *stop))block;
- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range;
- (CGRect)lineFragmentRectForCharacterAtIndex:(NSUInteger)index effectiveRange:(NSRange)effectiveRange;
- (CGRect)lineFragmentRectForLineAtIndex:(NSUInteger)index effectiveRange:(NSRange)effectiveRange;
- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index;

@property (nonatomic, assign, readonly) CGFloat layoutHeight;
@property (nonatomic, assign, readonly) CGSize layoutSize;
@property (nonatomic, assign, readonly) NSUInteger layoutLineCount;
@property (nonatomic, assign, readonly) NSRange layoutStringRange;
@property (nonatomic, assign, readonly) BOOL layoutUpToDate;

#pragma mark - Events
@property (nullable, nonatomic, weak) id<PPTextRendererEventDelegate> eventDelegate;
@end

@interface PPTextRenderer (Events)
- (nullable PPTextHighlightRange *)rangeInRanges:(NSArray<PPTextHighlightRange *> *)ranges forLayoutLocation:(CGPoint)location;
- (void)eventDelegateDidPressActiveRange:(PPTextActiveRange *)activeRange;
- (nullable NSArray *)eventDelegateActiveRanges;
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

@interface PPTextRenderer (Debug)
+ (void)disableDebugMode;
+ (void)enableDebugMode;
+ (void)setDebugModeEnabled:(BOOL)enabled;
+ (BOOL)debugModeEnabled;
+ (void)debugModeSetEverythingNeedsDisplay;
+ (void)debugModeSetEverythingNeedsDisplayForView:(id)view;
- (void)debugModeDrawLineFramesWithLayoutFrame:(PPTextLayoutFrame *)layoutFrame context:(CGContextRef)context offset:(UIOffset)offset;
@end

NS_ASSUME_NONNULL_END

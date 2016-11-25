//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextLayout.h"

@class PPTextLayoutFrame;

@protocol PPTextActiveRange <NSObject>
@property (nonatomic, strong) id userInfo;
@property (nonatomic, copy, readonly) NSString *keyRangeText;
@property (nonatomic, assign, readonly) NSRange keyRange;
@property (nonatomic, copy, readonly) NSString *rangeText;
@property (nonatomic, assign, readonly) NSInteger flavor;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, copy, readonly) NSString *text;

@optional
@property (nonatomic, strong) id dataBinding;
@end

@protocol PPTextRendererDelegate <NSObject>

@end

@protocol PPTextRendererEventDelegate <NSObject>
- (void)textRenderer:(PPTextRenderer *)arg1 didPressActiveRange:(id<PPTextActiveRange>)arg2;
- (NSArray *)activeRangesForTextRenderer:(PPTextRenderer *)textRenderer;
- (UIView *)contextViewForTextRenderer:(PPTextRenderer *)textRenderer;

@optional
- (BOOL)textRenderer:(PPTextRenderer *)textRenderer shouldInteractWithActiveRange:(id<PPTextActiveRange>)arg2;
@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) BOOL heightSensitiveLayout;
@property (nonatomic, weak) id <PPTextRendererDelegate> renderDelegate;
@property (nonatomic, weak) id <PPTextLayoutDelegate> layoutDelegate;
@property (nonatomic, strong) id <PPTextActiveRange> savedPressingActiveRange;
@property (nonatomic, strong) id <PPTextActiveRange> pressingActiveRange;
@property (nonatomic, assign) CGPoint drawingOrigin;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) UIOffset shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) PPTextLayout *textLayout;
- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(PPTextLayoutFrame *)layoutFrame;
- (void)drawHighlightedBackgroundForActiveRange:(id)arg1 rect:(CGRect)rect context:(CGContextRef)context;
- (void)drawAttachmentsWithAttributedString:(NSAttributedString *)attributedString
                                layoutFrame:(PPTextLayoutFrame *)layoutFrame
                                    context:(CGContextRef)context
                            shouldInterrupt:(void(^)(void))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context
          visibleRect:(CGRect)visibleRect
     placeAttachments:(BOOL)placeAttachments
 shouldInterruptBlock:(void(^)(void))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context shouldInterruptBlock:(void(^)(void))shouldInterruptBlock;
- (void)drawInContext:(CGContextRef)context;
- (void)draw;

#pragma mark - LayoutResult
- (NSUInteger)characterIndexForPoint:(CGPoint)point;
- (NSRange)characterRangeForBoundingRect:(CGRect)rect;
- (CGRect)boundingRectForCharacterRange:(NSRange)range;
- (CGPoint)locationForCharacterAtIndex:(NSUInteger)index;
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(void(^)(void))block;
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
@property (nonatomic, weak) id <PPTextRendererEventDelegate> eventDelegate;
@end

@interface PPTextRenderer (Events)
- (id<PPTextActiveRange>)rangeInRanges:(NSArray<id<PPTextActiveRange>> *)ranges forLayoutLocation:(CGPoint)location;
- (void)eventDelegateDidPressActiveRange:(id)arg1;
- (NSArray *)eventDelegateActiveRanges;
- (UIView *)eventDelegateContextView;
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

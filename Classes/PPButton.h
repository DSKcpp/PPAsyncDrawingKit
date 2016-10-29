//
//  PPButton.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"

NS_ASSUME_NONNULL_BEGIN

@class PPButtonInfo;

@interface PPButton : PPUIControl

@property(nonatomic, strong) PPButtonInfo *buttonInfo;
@property(nonatomic, assign) CGRect backgroundFrame;
@property(nonatomic, assign) CGRect imageFrame;
@property(nonatomic, assign) CGRect titleFrame;
@property(nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *backgroundImages;
@property(nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *images;
@property(nonatomic, strong) NSMutableDictionary<NSString *, UIColor *> *titleColors;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *titles;
@property(nonatomic, assign) BOOL shouldDelayHighlighted;
@property(nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property(nonatomic, strong) UILabel *titleLabel;

- (void)updateButtonInfo;
- (NSString *)stringOfState:(UIControlState)state;
- (nullable UIColor *)titleColorForState:(UIControlState)state;
- (nullable UIImage *)imageForState:(UIControlState)state;
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;
- (nullable NSString *)titleForState:(UIControlState)state;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)updateBackgroundImage:(UIImage *)image;
- (void)updateImage:(id)arg1;
- (void)updateTitle:(id)arg1;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)cancelTrackingWithEvent:(id)arg1;
- (void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (BOOL)continueTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (BOOL)canBecomeFirstResponder;
- (void)setEnabled:(BOOL)arg1;
- (void)setHighlighted:(BOOL)arg1;
- (CGRect)imageRectForContentRect:(CGRect)arg1;
- (CGRect)titleRectForContentRect:(CGRect)arg1;
- (CGRect)contentRectForBounds:(CGRect)arg1;
- (CGRect)backgroundRectForBounds:(CGRect)arg1;
- (void)setNeedsUpdateFrame;
- (void)updateSubviewFrames;
- (void)actualUpdateSubviewFrames;
- (void)updateContentsAndRelayout:(BOOL)relayout;
- (void)didCommitBoundsSizeChange;

- (void)asyncSetNeedsDisplay;
- (void)prepareDefaultValues;
- (void)configure;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithFrame:(CGRect)frame;
@end

@interface PPButtonInfo : NSObject
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END

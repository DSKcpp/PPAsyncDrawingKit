//
//  PPButton.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPButton : PPUIControl
@property (nonatomic, assign) CGRect backgroundFrame;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIImage *> *backgroundImages;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIImage *> *images;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIColor *> *titleColors;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *titles;
@property (nonatomic, assign) BOOL shouldDelayHighlighted;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, assign) BOOL needsUpdateFrame;
@property (nonatomic, assign) UIControlState trackingState;
@property (nonatomic, strong) UIFont *titleFont;

- (NSString *)stringOfState:(UIControlState)state;
- (nullable UIColor *)titleColorForState:(UIControlState)state;
- (nullable UIImage *)imageForState:(UIControlState)state;
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;
- (nullable NSString *)titleForState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

- (void)updateButtonInfo;
- (void)updateBackgroundImage:(UIImage *)backgroundImage;
- (void)updateImage:(UIImage *)image;
- (void)updateTitle:(NSString *)title;

- (BOOL)canBecomeFirstResponder;
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

NS_ASSUME_NONNULL_END

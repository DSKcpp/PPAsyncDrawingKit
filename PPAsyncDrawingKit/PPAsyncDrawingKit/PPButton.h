//
//  PPButton.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPControl.h>
#import <PPAsyncDrawingKit/PPTextView.h>
#import <PPAsyncDrawingKit/PPImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPButton : PPControl
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong, readonly) PPTextView *label;
@property (nonatomic, strong, readonly) PPImageView *imageView;
@property (nonatomic, assign, getter=isMergeDraw) BOOL mergeDraw;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property (nonatomic, assign) UIControlState trackingState;

- (instancetype)initWithFrame:(CGRect)frame;

- (NSString *)stringOfState:(UIControlState)state;
- (nullable UIColor *)titleColorForState:(UIControlState)state;
- (nullable UIImage *)imageForState:(UIControlState)state;
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;
- (nullable NSString *)titleForState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

- (BOOL)canBecomeFirstResponder;

- (void)setNeedsUpdateFrame;
- (void)updateSubviewFrames;
- (void)actualUpdateSubviewFrames;
- (void)updateContentsAndRelayout:(BOOL)relayout;
- (void)didCommitBoundsSizeChange;
@end

NS_ASSUME_NONNULL_END

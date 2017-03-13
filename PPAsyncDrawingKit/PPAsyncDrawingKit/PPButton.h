//
//  PPButton.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/27.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPButton : PPControl

/**
 字体 默认 15
 */
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 根据 UIControlState 获取 title
 
 @param state state
 @return title
 */
- (nullable NSString *)titleForState:(UIControlState)state;

/**
 根据 UIControlState 获取 title color

 @param state state
 @return title color
 */
- (nullable UIColor *)titleColorForState:(UIControlState)state;

/**
 根据 UIControlState 获取 image

 @param state state
 @return image
 */
- (nullable UIImage *)imageForState:(UIControlState)state;

/**
 根据 UIControlState 获取 background image

 @param state state
 @return background image
 */
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;


- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;


/**
 default is YES

 @return YES or NO
 */
- (BOOL)canBecomeFirstResponder;
@end

NS_ASSUME_NONNULL_END

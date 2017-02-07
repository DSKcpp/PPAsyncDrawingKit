//
//  PPImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPControl.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const PPImageViewRoundPath;
UIKIT_EXTERN NSString * const PPImageViewBorderPath;

@protocol PPAnimatedImageProtocol <NSObject>
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSUInteger currentAnimationImageIndex;

- (void)startAnimating;
- (void)stopAnimating;
@end

@interface PPImageView : PPControl <PPAnimatedImageProtocol>
@property (nullable, nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundedCorners;
@property (nonatomic, assign) UIViewContentMode contentMode;

@property (nonatomic, assign) BOOL showsCornerRadius;
@property (nonatomic, assign) BOOL showsBorderCornerRadius;
@property (nonatomic, assign) BOOL enableAsyncDrawing;
@property (nonatomic, assign) BOOL isNeedChangeContentModel;
@property (nonatomic, assign) BOOL updatePathWhenViewSizeChanges;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners;
@end

NS_ASSUME_NONNULL_END

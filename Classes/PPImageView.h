//
//  PPImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPImageView : PPUIControl
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect imageContentFrame;
@property (nonatomic, assign) BOOL isNeedChangeContentModel;
@property (nonatomic, assign) BOOL useUIImageView;
@property (nonatomic, assign) CGRect gradientColorRect;
@property (nonatomic, assign) BOOL updatePathWhenViewSizeChanges;
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) BOOL showsBorderCornerRadius;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundedCorners;
@property (nonatomic, assign) BOOL showsCornerRadius;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, assign) BOOL enableAsyncDrawing;
@property (nonatomic, strong) UIView *internalMaskView;
@property (nonatomic, assign) BOOL gradientColorsUpdated;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius;
- (instancetype)initWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners;
- (instancetype)initWithCachedRoundPath:(nullable CGPathRef)roundPath borderPath:(nullable CGPathRef)borderPath;

- (id)maskView;
- (void)imageDrawingFinished;
- (NSDictionary *)drawingComponentDictionary;
- (void)drawWithContext:(CGContextRef)context inRect:(CGRect)rect withComponents:(NSDictionary *)components;
@end

NS_ASSUME_NONNULL_END

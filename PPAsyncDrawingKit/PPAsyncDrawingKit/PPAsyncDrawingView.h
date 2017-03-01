//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 绘制类型，默认情况下是 Normal，非特殊情况无需手动修改状态

 - PPAsyncDrawingTypeNormal: 普通状态，根据 asyncDrawing 判断是否异步绘制
 - PPAsyncDrawingTypeTouch: 触摸状态，强制在主线程绘制
 */
typedef NS_ENUM(NSUInteger, PPAsyncDrawingType) {
    PPAsyncDrawingTypeNormal,
    PPAsyncDrawingTypeTouch
};

typedef void(^PPAsyncDrawingWillStartBlock)(BOOL asynchronously);
typedef void(^PPAsyncDrawingDidFinishBlock)(BOOL asynchronously, BOOL success);

@protocol PPAsyncDrawingProtocol <NSObject>
/**
 绘制方法，自动调用，必须实现
 
 @param rect 绘制 context 所在的 rect
 @param context 绘制所需的 context，不能为空
 @param asynchronously 是否异步绘制
 @return 是否绘制成功
 */
//- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;

@optional

/**
 将要开始绘制时的回调
 */
@property (nullable, nonatomic, copy) PPAsyncDrawingWillStartBlock drawingWillStartBlock;

/**
 绘制结束时的回调
 */
@property (nullable, nonatomic, copy) PPAsyncDrawingDidFinishBlock drawingDidFinishBlock;

/**
 如果在绘制过程中需要传参数，可以实现这个方法
 
 @return 绘制过程中需要的参数
 */
- (nullable NSDictionary *)currentDrawingUserInfo;
@end

/**
 这是一个基类，无法直接使用，需要继承并且实现相应的 draw 方法
 Tip：为了防止歧义，这个库中所有的 `Async` 关键字均表示使用多线程，如果相关 `Async` 属性是 No 的话，并不是 `Sync`，而是在主线程进行操作
 */
@interface PPAsyncDrawingView : UIView <PPAsyncDrawingProtocol>

/**
 控制全局是否开启异步绘制，默认允许
 */
@property (nonatomic, class, assign) BOOL globallyAsyncDrawingEnabled;

/**
 是否使用多线程进行绘制，默认是 YES
 */
@property (nonatomic, assign) BOOL asyncDrawing;

/**
 当前绘制类型，具体查看 PPAsyncDrawingType 定义
 */
@property (nonatomic, assign) PPAsyncDrawingType drawingType;

/**
 表示一个 View 绘制的次数，自增，用来打断快速滑动时的绘制，提高性能
 */
@property (nonatomic, assign, readonly) NSUInteger drawingCount;

/**
 在下一次绘制完成前，是否清空当前 context，默认是 YES
 */
@property (nonatomic, assign) BOOL clearsContextBeforeDrawing;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

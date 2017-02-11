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

CGFloat PPScreenScale();

/**
 绘制类型，默认情况下是 Normal，非特殊情况无需手动修改状态

 - PPAsyncDrawingTypeNormal: 普通状态，根据 asyncDrawing 判断是否异步绘制
 - PPAsyncDrawingTypeTouch: 触摸状态，强制在主线程绘制
 */
typedef NS_ENUM(NSUInteger, PPAsyncDrawingType) {
    PPAsyncDrawingTypeNormal,
    PPAsyncDrawingTypeTouch
};

/**
 这是一个基类，无法直接使用，需要继承并且实现相应的 draw 方法
 Tip：为了防止歧义，这个库中所有的 `Async` 关键字均表示使用多线程，如果相关 `Async` 属性是 No 的话，并不是 `Sync`，而是在主线程进行操作
 */
@interface PPAsyncDrawingView : UIView

/**
 控制全局是否开启异步绘制，默认允许
 */
@property (nonatomic, class, assign) BOOL globallyAsyncDrawingEnabled;

/**
 设置异步绘制所在的线程，如果不设置，并且 asyncDrawing 是 YES 的话，内部会自行开辟一个线程进行绘制，非特殊情况无需设置
 */
@property (nullable, nonatomic, assign) dispatch_queue_t asyncDrawQueue;

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

/**
 如果在绘制过程中需要传参数，可以实现这个方法

 @return 绘制过程中需要的参数
 */
- (nullable NSDictionary *)currentDrawingUserInfo;

/**
 绘制方法，自动调用，必须实现

 @param rect 绘制 context 所在的 rect
 @param context 绘制所需的 context，不能为空
 @param asynchronously 是否异步绘制
 @return 是否绘制成功
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;

/**
 绘制将要开始时会来到这个方法，可以做一些事情

 @param asynchronously 是否异步绘制
 */
- (void)drawingWillStartAsynchronously:(BOOL)asynchronously;

/**
 绘制中断或结束会来到这个方法，可以做一些事情

 @param asynchronously 是否异步绘制
 @param success 如果绘制被打断，则是 NO，成功的绘制完成，则是 YES
 */
- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success;
@end

NS_ASSUME_NONNULL_END

//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 异步绘制策略，默认 None

 - PPAsyncDrawingPolicyNone: 默认，将根据 contentsChangedAfterLastAsyncDrawing 来判断是否异步绘制
 - PPAsyncDrawingPolicyMainThread: 强制在主线程进行绘制
 - PPAsyncDrawingPolicyMultiThread: 强制使用多线程进行绘制
 */
typedef NS_ENUM(NSUInteger, PPAsyncDrawingPolicy) {
    PPAsyncDrawingPolicyNone,
    PPAsyncDrawingPolicyMainThread,
    PPAsyncDrawingPolicyMultiThread
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
 设置异步绘制所在的线程，如果不设置，并且 drawingPolicy 是 MultiThread 的话，内部会自行开辟一个线程进行绘制，非特殊情况无需设置
 */
@property (nullable, nonatomic, assign) dispatch_queue_t asyncDrawQueue;

/**
 默认是 NO，如果 drawingPolicy 是 None 的话，将有这个属性来判断是否异步绘制，一般在滚动的时候设为 YES，进行点击事件时设置为 NO，
 防止出现闪烁，YES 表示使用异步绘制
 */
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

/**
 绘制策略，参考 Enum 定义 Line 的注释
 */
@property (nonatomic, assign) PPAsyncDrawingPolicy drawingPolicy;

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
 绘制方法，自动调用，必须实现，和下面的方法只需要实现其中一个即可

 @param rect 绘制 context 所在的 rect
 @param context 绘制所需的 context，不能为空
 @param asynchronously 是否异步绘制
 @return 是否绘制成功
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;

/**
 绘制方法，自动调用，必须实现，和上面的方法只需要实现其中一个即可

 @param rect 绘制 context 所在的 rect
 @param context 绘制所需的 context，不能为空
 @param asynchronously 是否异步绘制
 @param userInfo 绘制所需的参数，来自 currentDrawingUserInfo
 @return 是否绘制成功
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(nullable NSDictionary *)userInfo;

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


/**
 马上异步绘制一次，会调用 setNeedsDisplay
 */
- (void)setNeedsDisplayAsync;
@end

NS_ASSUME_NONNULL_END

//
//  PPControl.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPAsyncDrawingView.h>

NS_ASSUME_NONNULL_BEGIN

/**
 这是一个处理点击事件的类，ImageView 和 Button 都继承自这个类
 */
@interface PPControl : PPAsyncDrawingView

/**
 默认是 YES，如果是 NO，那么会忽略所有的点击事件
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

/**
 默认是 NO，表示是是否被选择中
 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 默认是 NO，如果是 YES，则表示当前 View 处于高亮状态
 */
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;

/**
 表示是否正在响应触摸事件
 */
@property (nonatomic, assign, readonly, getter=isTracking) BOOL tracking;

/**
 表示手指是否触摸在当前 View 上
 */
@property (nonatomic, assign, readonly, getter=isTouchInside) BOOL touchInside;

/**

 默认是 NO，如果是 YES，设置 enabled / selected / highlighted 的时候将会自动调用 setNeedsDisplay 方法
 */
@property (nonatomic, assign) BOOL redrawsAutomaticallyWhenStateChange;

/**
 how to position content hozontally inside control.
 */
@property (nonatomic, assign) UIControlContentHorizontalAlignment contentHorizontalAlignment;

/**
 how to position content vertically inside control.
 */
@property (nonatomic, assign) UIControlContentVerticalAlignment contentVerticalAlignment;

/**
 could be more than one state (e.g. disabled|selected). synthesized from other flags.
 */
@property (nonatomic, assign, readonly) UIControlState state;

@property (nonatomic, assign, readonly) CGPoint touchStartPoint;

/**
  get info about target & actions. this makes it possible to enumerate all target/actions by checking for each event kind
 */
@property (nonatomic, readonly) NSSet *allTargets;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents;

- (BOOL)beginTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event;
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event; // touch is sometimes nil if cancelTracking calls through to this.
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event; // event may be nil if cancelled for non-event reasons, e.g. removed from window

- (nullable NSArray<NSString *> *)actionsForTarget:(nullable id)target forControlEvent:(UIControlEvents)controlEvent;    // single event. returns NSArray of NSString selector names. returns nil if none

/**
 send the action. the first method is called for the event and is a point at which you can observe or override behavior. it is called repeately by the second.
 */
- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event;

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;                        // send all actions associated with events
@end

NS_ASSUME_NONNULL_END

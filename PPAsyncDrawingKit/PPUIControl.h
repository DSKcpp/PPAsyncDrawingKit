//
//  PPUIControl.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A UIControl.
 */
@interface PPUIControl : PPAsyncDrawingView
@property (nonatomic, assign, getter=isEnabled) BOOL enabled; // default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, assign, getter=isSelected) BOOL selected; // default is NO may be used by some subclasses or by application
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted; // default is NO. this gets set/cleared automatically when touch enters/exits during tracking and cleared on up
@property (nonatomic, assign, readonly, getter=isTracking) BOOL tracking;
@property (nonatomic, assign, readonly, getter=isTouchInside) BOOL touchInside;
@property (nonatomic, assign) BOOL redrawsAutomaticallyWhenStateChange; // default is No. if YES, set enabled / selected / highlighted auto execute [self setNeedsDisplay].

@property (nonatomic, assign) UIControlContentHorizontalAlignment contentHorizontalAlignment; // how to position content hozontally inside control.
@property (nonatomic, assign) UIControlContentVerticalAlignment contentVerticalAlignment;  // how to position content vertically inside control.
@property (nonatomic, assign, readonly) UIControlState state; // could be more than one state (e.g. disabled|selected). synthesized from other flags.

@property (nonatomic, assign, readonly) CGPoint touchStartPoint;

@property(nonatomic, readonly) NSSet *allTargets; // get info about target & actions. this makes it possible to enumerate all target/actions by checking for each event kind
@property(nonatomic, readonly) UIControlEvents allControlEvents;                            // list of all events that have at least one action

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents;

- (BOOL)beginTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event;
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event; // touch is sometimes nil if cancelTracking calls through to this.
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event; // event may be nil if cancelled for non-event reasons, e.g. removed from window

- (nullable NSArray<NSString *> *)actionsForTarget:(nullable id)target forControlEvent:(UIControlEvents)controlEvent;    // single event. returns NSArray of NSString selector names. returns nil if none

// send the action. the first method is called for the event and is a point at which you can observe or override behavior. it is called repeately by the second.
- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event;
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;                        // send all actions associated with events
@end

NS_ASSUME_NONNULL_END

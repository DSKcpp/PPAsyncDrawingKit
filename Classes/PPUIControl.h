//
//  PPUIControl.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"

@interface PPUIControl : PPAsyncDrawingView

@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign, getter=isTracking) BOOL tracking;
@property (nonatomic, assign, getter=isTouchInside) BOOL touchInside;
@property (nonatomic, assign) NSInteger contentHorizontalAlignment;
@property (nonatomic, assign) NSInteger contentVerticalAlignment;
@property (nonatomic, assign) CGPoint touchStartPoint;
@property (nonatomic, assign, readonly) UIControlState state;
@property (nonatomic, assign, readonly) BOOL redrawsAutomaticallyWhenStateChange;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)cancelTrackingWithTouch:(UITouch *)touch WithEvent:(UIEvent *)event;

- (void)sendAction:(SEL)action to:(id)to forEvent:(UIEvent *)event;
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;

- (id)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent;

- (NSSet<id> *)allTargets;
- (UIControlEvents)allControllEvents;
@end

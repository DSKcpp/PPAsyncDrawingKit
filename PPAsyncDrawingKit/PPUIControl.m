//
//  PPUIControl.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"

@interface PPUIControlTargetAction : NSObject
@property (nonatomic, assign) SEL action;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) UIControlEvents controlEvents;
@end

@implementation PPUIControlTargetAction

- (BOOL)isEqual:(id)object
{
    if (object != self) {
        if ([object isKindOfClass:[self class]]) {
            PPUIControlTargetAction *obj = (PPUIControlTargetAction *)object;
            if (obj.target == self.target && obj.action == self.action && obj.controlEvents == self.controlEvents) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}
@end


@interface PPUIControl ()
@property (nonatomic, strong) NSMutableArray<PPUIControlTargetAction *> *targetActions;
@end

@implementation PPUIControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.enabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)dealloc
{
    _targetActions = nil;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (action) {
        PPUIControlTargetAction *targetAction = [[PPUIControlTargetAction alloc] init];
        targetAction.target = target;
        targetAction.action = action;
        targetAction.controlEvents = controlEvents;
        [self.targetActions addObject:targetAction];
    }
}

- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray<PPUIControlTargetAction *> *removeTargetAcitons = [NSMutableArray array];
    for (PPUIControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && action == targetAction.action && controlEvents == targetAction.controlEvents) {
            [removeTargetAcitons addObject:targetAction];
        }
    }
    [self.targetActions removeObjectsInArray:removeTargetAcitons];
}

- (NSArray<NSString *> *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray<NSString *> *actions = [NSMutableArray array];
    for (PPUIControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && controlEvent == targetAction.controlEvents) {
            [actions addObject:NSStringFromSelector(targetAction.action)];
        }
    }
    return actions;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touchInside = YES;
    UITouch *touch = [touches anyObject];
    self.tracking = [self beginTrackingWithTouch:touch withEvent:event];
    self.highlighted = YES;
    if (self.tracking) {
        UIControlEvents controlEvents = UIControlEventTouchDown;
        if ([touch tapCount] > 1) {
            controlEvents = UIControlEventTouchDown | UIControlEventTouchDownRepeat;
        }
        [self _sendActionsForControlEvents:controlEvents withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point;
    if (touch) {
        point = [touch locationInView:self];
    } else {
        point = CGPointZero;
    }
    BOOL touchInside = [self pointInside:point withEvent:event];
    self.touchInside = touchInside;
    self.highlighted = YES;
    if (self.tracking) {
        BOOL continueTracking = [self continueTrackingWithTouch:touch withEvent:event];;
        self.tracking = continueTracking;
        if (continueTracking) {
            UIControlEvents controlEvents = UIControlEventTouchDragOutside;
            if (self.touchInside) {
                controlEvents = UIControlEventTouchDragInside;
            }
            if (!touchInside && self.touchInside) {
                controlEvents = controlEvents | UIControlEventTouchDragEnter;
            } else if (touchInside && !self.touchInside) {
                controlEvents = controlEvents | UIControlEventTouchDragExit;
            }
            [self _sendActionsForControlEvents:controlEvents withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point;
    if (touch) {
        point = [touch locationInView:self];
    } else {
        point = CGPointZero;
    }
    self.touchInside = [self pointInside:point withEvent:event];
    self.highlighted = NO;
    if (self.tracking) {
        [self endTrackingWithTouch:touch withEvent:event];
        UIControlEvents controlEvents = UIControlEventTouchUpOutside;
        if (self.touchInside) {
            controlEvents = UIControlEventTouchUpInside;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _sendActionsForControlEvents:controlEvents withEvent:event];
        });
    }
    self.touchInside = NO;
    self.tracking = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (self.tracking) {
        [self cancelTrackingWithEvent:event];
        [self _sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
    }
    self.tracking = NO;
    self.touchInside = NO;
}

- (void)sendAction:(SEL)action to:(id)to forEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:action to:to from:self forEvent:event];
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    [self _sendActionsForControlEvents:controlEvents withEvent:nil];
}

- (NSSet<id> *)allTargets
{
    NSArray<id> *targets = [self.targetActions valueForKey:@"target"];
    return [NSSet setWithArray:targets];
}

- (UIControlEvents)allControlEvents
{
    UIControlEvents controlEvents;
    for (PPUIControlTargetAction *targetAction in self.targetActions) {
        controlEvents += targetAction.controlEvents;
    }
    return controlEvents;
}

- (void)_stateWillChange
{
    
}

- (void)_stateDidChange
{
    if (self.redrawsAutomaticallyWhenStateChange) {
        [self setNeedsDisplay];
    }
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    [self.targetActions enumerateObjectsUsingBlock:^(PPUIControlTargetAction * _Nonnull targetAction, NSUInteger idx, BOOL * _Nonnull stop) {
        if (targetAction.target && controlEvents & targetAction.controlEvents) {
            [self sendAction:targetAction.action to:targetAction.target forEvent:event];
        }
    }];
}

- (NSMutableArray<PPUIControlTargetAction *> *)targetActions
{
    if (_targetActions == nil) {
        _targetActions = @[].mutableCopy;
    }
    return _targetActions;
}

@end

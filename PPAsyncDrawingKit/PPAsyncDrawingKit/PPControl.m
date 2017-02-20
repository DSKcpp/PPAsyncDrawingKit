//
//  PPControl.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPControl.h"

@interface PPControlTargetAction : NSObject
@property (nonatomic, assign) SEL action;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) UIControlEvents controlEvents;
@end

@implementation PPControlTargetAction @end

@interface PPControl ()
{
    NSMutableArray<PPControlTargetAction *> *_targetActions;
}

@end

@implementation PPControl
@dynamic allTargets;

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

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted) {
        [self _stateWillChange];
        _highlighted = highlighted;
        [self _stateDidChange];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled != enabled) {
        [self _stateWillChange];
        _enabled = enabled;
        [self _stateDidChange];
        self.userInteractionEnabled = enabled;
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        [self _stateWillChange];
        _selected = selected;
        [self _stateDidChange];
    }
}

- (UIControlState)state
{
    UIControlState _state = UIControlStateNormal;
    if (self.isHighlighted) {
        _state = UIControlStateHighlighted;
    }
    if (!self.isEnabled) {
        _state = _state | UIControlStateDisabled;
    }
    if (self.isSelected) {
        _state = _state | UIControlStateSelected;
    }
    return _state;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (action) {
        PPControlTargetAction *targetAction = [[PPControlTargetAction alloc] init];
        targetAction.target = target;
        targetAction.action = action;
        targetAction.controlEvents = controlEvents;
        [self.targetActions addObject:targetAction];
    }
}

- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray<PPControlTargetAction *> *removeTargetAcitons = @[].mutableCopy;
    for (PPControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && action == targetAction.action && controlEvents == targetAction.controlEvents) {
            [removeTargetAcitons addObject:targetAction];
        }
    }
    [self.targetActions removeObjectsInArray:removeTargetAcitons];
}

- (NSArray<NSString *> *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray<NSString *> *actions = @[].mutableCopy;
    for (PPControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && controlEvent == targetAction.controlEvents) {
            [actions addObject:NSStringFromSelector(targetAction.action)];
        }
    }
    return actions;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { return  YES; }

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { return  YES; }

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { }

- (void)cancelTrackingWithEvent:(UIEvent *)event { }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchInside = YES;
    UITouch *touch = [touches anyObject];
    _tracking = [self beginTrackingWithTouch:touch withEvent:event];
    self.highlighted = YES;
    if (self.isTracking) {
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
    _touchInside = touchInside;
    self.highlighted = touchInside;
    if (_tracking) {
        BOOL continueTracking = [self continueTrackingWithTouch:touch withEvent:event];;
        _tracking = continueTracking;
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
    } else {
        if (!touchInside) {
            [self _sendActionsForControlEvents:UIControlEventTouchDragOutside withEvent:event];
        } else {
            [self _sendActionsForControlEvents:UIControlEventTouchDragInside withEvent:event];
            _tracking = YES;
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
    _touchInside = [self pointInside:point withEvent:event];
    self.highlighted = NO;
    if (_tracking) {
        [self endTrackingWithTouch:touch withEvent:event];
        UIControlEvents controlEvents = UIControlEventTouchUpOutside;
        if (self.touchInside) {
            controlEvents = UIControlEventTouchUpInside;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _sendActionsForControlEvents:controlEvents withEvent:event];
        });
    }
    _touchInside = NO;
    _tracking = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (self.tracking) {
        [self cancelTrackingWithEvent:event];
        [self _sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
    }
    _tracking = NO;
    _touchInside = NO;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:action to:target from:self forEvent:event];
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    [self _sendActionsForControlEvents:controlEvents withEvent:nil];
}

- (void)_stateWillChange { }

- (void)_stateDidChange
{
    if (_redrawsAutomaticallyWhenStateChange) {
        [self setNeedsDisplay];
    }
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    [self.targetActions enumerateObjectsUsingBlock:^(PPControlTargetAction * _Nonnull targetAction, NSUInteger idx, BOOL * _Nonnull stop) {
        if (targetAction.target && controlEvents & targetAction.controlEvents) {
            [self sendAction:targetAction.action to:targetAction.target forEvent:event];
        }
    }];
}

- (NSMutableArray<PPControlTargetAction *> *)targetActions
{
    if (!_targetActions) {
        _targetActions = @[].mutableCopy;
    }
    return _targetActions;
}

- (NSSet *)allTargets
{
    NSArray *targets = [self.targetActions valueForKey:@"target"];
    return [NSSet setWithArray:targets];
}

- (NSString *)stringOfState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            return @"UIControlStateNormal";
        case UIControlStateHighlighted:
            return @"UIControlStateHighlighted";
        case UIControlStateDisabled:
            return @"UIControlStateDisabled";
        case UIControlStateSelected:
            return @"UIControlStateSelected";
        case UIControlStateFocused:
            return @"UIControlStateFocused";
        case UIControlStateApplication:
            return @"UIControlStateApplication";
        case UIControlStateReserved:
            return @"UIControlStateReserved";
    }
}

@end

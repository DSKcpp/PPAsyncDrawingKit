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
    
}

- (NSArray<NSString *> *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    return nil;
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

- (void)cancelTrackingWithTouch:(UITouch *)touch WithEvent:(UIEvent *)event
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touchInside = YES;
    UITouch *touch = [touches anyObject];
    self.tracking = [self beginTrackingWithTouch:touch withEvent:event];
    self.highlighted = YES;
    if (_tracking) {
        if ([touch tapCount] > 1) {
            [self _sendActionsForControlEvents:UIControlEventTouchDown withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point;
    if (touch) {
        point = [touch locationInView:self];
    } else {
        
    }
    self.touchInside = [self pointInside:point withEvent:event];
    self.highlighted = YES;
    if (self.tracking) {
        self.tracking = [self continueTrackingWithTouch:touch withEvent:event];
        if (self.tracking) {
            [self _sendActionsForControlEvents:UIControlEventTouchDown withEvent:event];
        }
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self _sendActionsForControlEvents:UIControlEventTouchUpInside withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
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

- (UIControlEvents)allControllEvents
{
    return 0;
}

- (void)_stateWillChange
{
    
}

- (void)_stateDidChange
{
    if (![self redrawsAutomaticallyWhenStateChange]) {
        return;
    }
    [self setNeedsDisplay];
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    [self.targetActions enumerateObjectsUsingBlock:^(PPUIControlTargetAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sendAction:obj.action to:obj.target forEvent:event];
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

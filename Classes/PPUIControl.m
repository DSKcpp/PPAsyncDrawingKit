//
//  PPUIControl.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"
#import "PPUIControlTargetAction.h"

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
    _touchInside = YES;
    UITouch *touch = [touches anyObject];
    _tracking = [self beginTrackingWithTouch:touch withEvent:event];
    _highlighted = YES;
    if (_tracking) {
        if ([touch tapCount] > 1) {
            
        }
    }
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
    
}

- (NSMutableArray<PPUIControlTargetAction *> *)targetActions
{
    if (_targetActions == nil) {
        _targetActions = @[].mutableCopy;
    }
    return _targetActions;
}

@end

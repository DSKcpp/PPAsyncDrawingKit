//
//  PPTextUndoManager.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextUndoManager.h"

@implementation PPTextUndoManager
- (void)undo
{
    [self closeAllOpenGroups];
    [super undo];
}

- (void)willBeginUndoRegistrationWithType:(int)type
{
    _registeringOperationType = type;
}

- (void)didFinishUndoRegistration
{
    _recentOperationType = _registeringOperationType;
    _registeringOperationType = 0;
}

- (void)enableUndoRegistration
{
    [self closeAllOpenGroups];
    [super enableUndoRegistration];
}

- (void)disableUndoRegistration
{
    [self closeAllOpenGroups];
    [super disableUndoRegistration];
}

- (void)beginUndoGrouping
{
    _numberOfOpenGroups += 1;
    [super beginUndoGrouping];
}

- (void)endUndoGrouping
{
    if (_numberOfOpenGroups) {
        _numberOfOpenGroups -= 1;
        [super endUndoGrouping];
    }
}

- (void)beginUndoGroupingIfNeeded
{
    if (_numberOfOpenGroups == 0) {
        [self beginUndoGrouping];
    }
}

- (void)closeAllOpenGroups
{
    if (_numberOfOpenGroups != 0) {
        do {
            [self endUndoGrouping];
        } while (_numberOfOpenGroups != 0);
    }
    _recentOperationType = 0;
}

- (void)removeAllActions
{
    [self closeAllOpenGroups];
    [super removeAllActions];
}

@end

//
//  PPTextUndoManager.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTextUndoManager : NSUndoManager
@property(nonatomic) NSUInteger numberOfOpenGroups;
@property(nonatomic) int registeringOperationType;
@property(nonatomic) int recentOperationType;

- (void)beginUndoGroupingIfNeeded;
- (void)willBeginUndoRegistrationWithType:(int)type;
- (void)didFinishUndoRegistration;
- (void)closeAllOpenGroups;
@end

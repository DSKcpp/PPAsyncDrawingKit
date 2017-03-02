//
//  PPTableView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/5.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTableView.h"
#import "PPAsyncDrawingView.h"

@implementation PPTableView

- (void)reloadData
{
    [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:NO];
    
    [super reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:YES];
    });
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:NO];
    
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:YES];
    });
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:NO];
    
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:YES];
    });
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:NO];
    
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PPAsyncDrawingView setGloballyAsyncDrawingEnabled:YES];
    });
}
@end

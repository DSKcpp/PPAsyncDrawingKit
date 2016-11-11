//
//  PPNameLabel.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPNameLabel.h"

@implementation PPNameLabel

- (void)setUser:(WBUser *)user
{
    if (_user != user) {
        _user = user;
        [self setContentsChangedAfterLastAsyncDrawing:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async
{
    return YES;
}
@end

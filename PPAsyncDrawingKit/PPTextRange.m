//
//  PPTextRange.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextRange.h"

@implementation PPTextRange
@dynamic start;
@dynamic end;

- (NSRange)range
{
    return NSMakeRange(self.start.index, self.end.index);
}
@end

@implementation PPTextPosition


@end

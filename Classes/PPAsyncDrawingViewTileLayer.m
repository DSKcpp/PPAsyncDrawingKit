//
//  PPAsyncDrawingViewTileLayer.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/7/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingViewTileLayer.h"
#import "PPAsyncDrawingView.h"

@implementation PPAsyncDrawingViewTileLayer
- (void)display
{
    [self.asyncDrawingView displayLayer:self];
}

- (id)actionForKey:(id)arg1
{
    return nil;
}
@end

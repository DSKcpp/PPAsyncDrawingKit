//
//  WBTimelineContentImageViewLayouter.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineContentImageViewLayouter.h"

@implementation WBTimelineContentImageViewLayouter
- (instancetype)init
{
    if (self = [super init]) {
        self.imageRowLayouters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_layoutIfNeeded
{
//    if (_needRelayout) {
//        if (self numberOfGridImagesRowsIn:<#(id)#>) {
//            
//        }
//    }
}

- (void)_resetLayouterWithImageCount:(NSUInteger)imageCount
{
    self.imageCount = imageCount;
}
@end

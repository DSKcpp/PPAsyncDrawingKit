//
//  PPContentImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/19.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPContentImageView.h"

@implementation PPContentImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoPlayGifIfReady = NO;
        self.allowPlayGif = NO;
        self.purposeType = 0;
        self.placeFlagImgOutside = NO;
    }
    return self;
}
@end

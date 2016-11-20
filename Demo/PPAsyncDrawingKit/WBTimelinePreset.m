//
//  WBTimelinePreset.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/20.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelinePreset.h"

@implementation WBTimelinePreset
+ (instancetype)sharedInstance
{
    static WBTimelinePreset *_sharedInstance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _actionButtonsHeight = 34.0f;
        _titleItemHeight = 34.0f;
        _leftSpacing = 12.0f;
        _rightSpacing = 12.0f;
        _avatarSize = 39.0f;
        _avatarCornerRadius = 19.5f;
        _avatarTop = 15.0f;
        _nameLabelLeft = 62.0f;
        _nameLabelTop = 12.0f;
        _titleIconTop = 9.5f;
        _titleIconLeft = 11.0f;
        _titleIconSize = 15.0f;
    }
    return self;
}
@end

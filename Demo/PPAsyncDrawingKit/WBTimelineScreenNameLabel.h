//
//  WBTimelineScreenNameLabel.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPUIControl.h"

@class WBUser;

@interface WBTimelineScreenNameLabel : PPUIControl
@property (nonatomic, strong) WBUser *user;
@property (nonatomic, strong) NSArray *remoteIconImageViews;
@property (nonatomic, assign) struct CGRect currentTextFrame;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSIndexSet *remoteIconIndexSet;
@property (nonatomic, assign) BOOL isNeedShowDefaultIcon;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *redNameTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (readonly, nonatomic) CGRect touchableRect;
@property (nonatomic, assign) double currentTextBaselineOrigin;
@property (nonatomic, assign) long long options;
- (BOOL)pointInside:(CGPoint)arg1 withEvent:(id)arg2;
- (void)addRemoteIcons;
- (void)removeRemoteIcons;
- (id)defaultIcons;
- (void)updateIcons;
- (BOOL)redrawsAutomaticallyWhenStateChange;
@end

//
//  WBTimelinePreset.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/20.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBTimelinePreset : NSObject
@property (nonatomic, class, readonly) WBTimelinePreset *sharedInstance;

@property (nonatomic, assign, readonly) CGFloat leftSpacing;
@property (nonatomic, assign, readonly) CGFloat rightSpacing;

@property (nonatomic, assign, readonly) CGFloat titleItemHeight;

@property (nonatomic, assign, readonly) CGFloat actionButtonsHeight;

@property (nonatomic, assign, readonly) CGFloat avatarTop;
@property (nonatomic, assign, readonly) CGFloat avatarSize;
@property (nonatomic, assign, readonly) CGFloat avatarCornerRadius;

@property (nonatomic, assign, readonly) CGFloat nameLabelLeft;
@property (nonatomic, assign, readonly) CGFloat nameLabelTop;

@property (nonatomic, assign, readonly) CGFloat titleIconLeft;
@property (nonatomic, assign, readonly) CGFloat titleIconTop;
@property (nonatomic, assign, readonly) CGFloat titleIconSize;
@end

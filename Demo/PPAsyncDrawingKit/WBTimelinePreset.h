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
@property (class, strong, readonly) WBTimelinePreset *sharedInstance;

@property (nonatomic, assign, readonly) CGFloat leftSpacing;
@property (nonatomic, assign, readonly) CGFloat rightSpacing;

#pragma mark - Title Area
@property (nonatomic, assign, readonly) CGFloat titleAreaHeight;
@property (nonatomic, assign, readonly) CGFloat titleIconLeft;
@property (nonatomic, assign, readonly) CGFloat titleIconTop;
@property (nonatomic, assign, readonly) CGFloat titleIconSize;
@property (nonatomic, assign, readonly) CGFloat titleFontSize;

#pragma mark - Header Area
@property (nonatomic, assign, readonly) CGFloat headerAreaHeight;
@property (nonatomic, assign, readonly) CGFloat avatarTop;
@property (nonatomic, assign, readonly) CGFloat avatarSize;
@property (nonatomic, assign, readonly) CGFloat avatarCornerRadius;
@property (nonatomic, assign, readonly) CGFloat nicknameLeft;
@property (nonatomic, assign, readonly) CGFloat nicknameTop;
@property (nonatomic, assign, readonly) CGFloat nicknameFontSize;
@property (nonatomic, assign, readonly) CGFloat sourceFontSize;

#pragma mark - Image Area
@property (nonatomic, assign, readonly) CGFloat gridImageTop;
@property (nonatomic, assign, readonly) CGFloat gridImageBottom;
@property (nonatomic, assign, readonly) CGFloat gridImageSize;
@property (nonatomic, assign, readonly) CGFloat gridImageSpacing;
@property (nonatomic, assign, readonly) CGFloat verticalImageWidth;
@property (nonatomic, assign, readonly) CGFloat verticalImageHeight;

#pragma mark - ActionButtons Area
@property (nonatomic, assign, readonly) CGFloat actionButtonsHeight;
@end

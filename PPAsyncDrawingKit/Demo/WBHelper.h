//
//  WBHelper.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBHelper : NSObject
+ (nullable NSURL *)defaultURLForImageURL:(id)imageURL;
@end

@interface WBEmoticonManager : NSObject
@property (nonatomic, strong, class, readonly) WBEmoticonManager *sharedMangaer;
@property (nonatomic, strong, readonly) NSDictionary *config;

- (nullable UIImage *)imageWithEmotionName:(NSString *)name;
@end

@interface WBTimelinePreset : NSObject
@property (class, strong, readonly) WBTimelinePreset *sharedInstance;

@property (nonatomic, assign, readonly) NSInteger numberOfLines;

@property (nonatomic, assign, readonly) CGFloat leftSpacing;
@property (nonatomic, assign, readonly) CGFloat rightSpacing;
@property (nonatomic, assign, readonly) CGFloat defaultMargin;
@property (nonatomic, assign, readonly) CGFloat maxWidth;
@property (nonatomic, assign, readonly) CGFloat minHeight;

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

#pragma mark - PageInfo Area
@property (nonatomic, assign, readonly) CGFloat pageInfoHeight;

#pragma mark - Color
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, strong, readonly) UIColor *subtextColor;
@property (nonatomic, strong, readonly) UIColor *highlightTextColor;
@property (nonatomic, strong, readonly) UIColor *textBorderColor;

#pragma mark - Font
@property (nonatomic, assign, readonly) CGFloat textFont;
@property (nonatomic, assign, readonly) CGFloat subtextFont;
@end


NS_ASSUME_NONNULL_END

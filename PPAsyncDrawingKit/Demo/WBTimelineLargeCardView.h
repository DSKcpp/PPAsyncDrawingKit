//
//  WBTimelineLargeCardView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPAsyncDrawingView.h"
#import "WBTimelineItem.h"
#import "PPMultiplexTextView.h"
#import "PPWebImageView.h"

@interface WBTimelineLargeCardTextView : PPMultiplexTextView
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;
@property (nonatomic, strong) PPTextLayout *titleTextLayout;
@property (nonatomic, strong) PPTextLayout *descTextLayout;
@end

@interface WBPageInfoBaseCardView : UIView
@property (nonatomic, strong) PPWebImageView *imageView;
@property (nonatomic, strong) WBTimelineLargeCardTextView *textView;
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;

+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type;
+ (CGFloat)heightConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type;
@end

@interface WBVideoLargeCardView : WBPageInfoBaseCardView

@end


@protocol WBTimelineLargeCardViewDelegate <NSObject>

@optional
- (void)didPressVideoCard;
- (NSString *)pageInfoIdentifier;
@end

@interface WBTimelineLargeCardView : UIButton
+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type;
@property (nonatomic, assign) BOOL needsBackground;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) WBPageInfoBaseCardView *cardView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, weak) id<WBTimelineLargeCardViewDelegate> delegate;
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;

- (instancetype)initWithFrame:(CGRect)frame;
@end



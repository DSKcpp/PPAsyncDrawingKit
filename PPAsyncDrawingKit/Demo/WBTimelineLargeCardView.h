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
#import "PPImageView.h"

@interface WBTimelineLargeCardTextView : PPMultiplexTextView
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;
@property (nonatomic, strong) PPTextLayout *titleTextLayout;
@property (nonatomic, strong) PPTextLayout *descTextLayout;
@end

@interface WBPageInfoBaseCardView : UIView
@property (nonatomic, strong) PPImageView *imageView;
@property (nonatomic, strong) WBTimelineLargeCardTextView *textView;
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;

@end

@interface WBTimelineLargeCardView : UIButton
@property (nonatomic, strong) WBPageInfoBaseCardView *cardView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;

- (instancetype)initWithFrame:(CGRect)frame;
@end



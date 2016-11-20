//
//  WBTimelineActionButtonsView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTimelineItem;
@class PPButton;

@interface WBTimelineActionButtonsView : UIView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong, readonly) PPButton *retweetButton;
@property (nonatomic, strong, readonly) PPButton *commentButton;
@property (nonatomic, strong, readonly) PPButton *likeButton;
@end

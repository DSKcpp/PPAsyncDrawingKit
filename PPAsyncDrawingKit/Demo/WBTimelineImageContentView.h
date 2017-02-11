//
//  WBTimelineImageContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTimelineItem.h"
#import "PPWebImageView.h"

@interface WBTimelineImageView : PPWebImageView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@end

@interface WBTimelineImageContentView : UIView
@property (nonatomic, strong) NSMutableArray<WBTimelineImageView *> *idleContentImageViewAry;
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) NSArray<WBTimelinePicture *> *pictures;
@property (nonatomic, strong) NSMutableArray<WBTimelineImageView *> *imageViews;
- (void)addToIdleContentImageViewAry:(WBTimelineImageView *)imageView;
- (WBTimelineImageView *)dequeueReusableImageView;
- (void)reloadImageViews;
@end

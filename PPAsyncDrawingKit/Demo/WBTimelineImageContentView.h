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

@protocol WBTimelineImageContentViewDelegate <NSObject>
@optional
//- (UIViewController *)timelineImageContentView:(WBTimelineImageContentView *)arg1 peekingViewControllerForPicture:(WBTimelinePicture *)arg2;
//- (void)timelineImageContentView:(WBTimelineImageContentView *)arg1 pictureSizeDidChange:(WBTimelinePicture *)arg2;
//- (void)timelineImageContentView:(WBTimelineImageContentView *)arg1 didSelectPicture:(WBTimelinePicture *)arg2;
@end

@interface WBTimelineImageView : PPWebImageView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@end

@interface WBTimelineImageContentView : UIView
@property (nonatomic, strong) NSMutableArray<WBTimelineImageView *> *idleContentImageViewAry;
@property (nonatomic, strong) NSMutableArray<WBTimelineImageView *> *contentImageViewAry;
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, assign) NSRange picsArrayShowRange;
@property (nonatomic, assign) BOOL allowShowPicNumFlag;
@property (nonatomic, assign) CGRect imageLayerFrame;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) NSArray<WBTimelinePicture *> *pictures;
@property (nonatomic, assign) BOOL animationWhenImageReceived;
@property (nonatomic, weak) id <WBTimelineImageContentViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableAsyncDrawing;
@property (nonatomic, strong) NSMutableArray<WBTimelineImageView *> *imageViews;
@property (nonatomic, assign) BOOL forceHidden;
- (void)addToIdleContentImageViewAry:(WBTimelineImageView *)imageView;
- (WBTimelineImageView *)dequeueReusableImageView;
- (void)reloadImageViews;
@end

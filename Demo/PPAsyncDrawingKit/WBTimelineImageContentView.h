//
//  WBTimelineImageContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPImageView.h"
#import "WBTimelineItem.h"

@protocol WBTimelineImageContentViewDelegate <NSObject>
@optional
//- (UIViewController *)timelineImageContentView:(WBTimelineImageContentView *)arg1 peekingViewControllerForPicture:(WBTimelinePicture *)arg2;
//- (void)timelineImageContentView:(WBTimelineImageContentView *)arg1 pictureSizeDidChange:(WBTimelinePicture *)arg2;
//- (void)timelineImageContentView:(WBTimelineImageContentView *)arg1 didSelectPicture:(WBTimelinePicture *)arg2;
@end

@interface WBTimelineImageView : PPImageView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@end

@interface WBTimelineImageContentView : UIView
+ (BOOL)isGifNewAspectEnabled;
+ (CGRect)rectForImageLayer:(id)arg1 imageSize:(CGSize)arg2;
+ (CGSize)sizeForImages:(id)arg1 maxWidth:(unsigned long long)arg2;

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
- (id)previewingContext:(id)arg1 viewControllerForLocation:(CGPoint)arg2;
- (BOOL)previewingContextShouldBeginPreview:(id)arg1;
- (BOOL)shouldPresentVideoTimeline;
- (CGRect)frameForIndex:(long long)arg1 count:(long long)arg2;
- (void)addToIdleContentImageViewAry:(id)arg1;
- (WBTimelineImageView *)dequeueReusableImageView;
- (id)imageViewForImageURL:(id)arg1 reusing:(BOOL)arg2;
- (id)imageViewForImageURL:(id)arg1;
- (void)reloadImageViews;
- (void)setHidden:(BOOL)hidden;
@end

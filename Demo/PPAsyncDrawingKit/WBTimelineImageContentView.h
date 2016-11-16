//
//  WBTimelineImageContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTimelineItem;
@class WBTimelineContentImageViewLayouter;

@interface WBTimelineImageContentView : UIView
+ (BOOL)isGifNewAspectEnabled;
+ (CGRect)rectForImageLayer:(id)arg1 imageSize:(CGSize)arg2;
+ (CGSize)sizeForImages:(id)arg1 maxWidth:(unsigned long long)arg2;
@property(retain, nonatomic) NSMutableArray *idleContentImageViewAry;
@property(retain, nonatomic) NSMutableArray *contentImageViewAry;
@property(retain, nonatomic) NSObject<OS_dispatch_queue> *imageLoadQueue;
@property(retain, nonatomic) WBTimelineItem *timelineItem;
@property(nonatomic) NSRange picsArrayShowRange;
@property(nonatomic) BOOL allowShowPicNumFlag;
@property(retain, nonatomic) WBTimelineContentImageViewLayouter *layouter;
@property(nonatomic) CGRect imageLayerFrame;
@property(nonatomic) BOOL highlighted;
@property(copy, nonatomic) NSArray *pictures;
@property(nonatomic) BOOL animationWhenImageReceived;
@property(nonatomic, weak) NSObject<WBTimelineImageContentViewDelegate> *delegate;
@property(nonatomic) BOOL enableAsyncDrawing;
@property(retain, nonatomic) NSMutableArray *imageViews;
@property(nonatomic) BOOL forceHidden;
- (id)previewingContext:(id)arg1 viewControllerForLocation:(struct CGPoint)arg2;
- (BOOL)previewingContextShouldBeginPreview:(id)arg1;
- (BOOL)shouldPresentVideoTimeline;
- (void)viewWillAppear:(BOOL)arg1;
- (void)viewDidDisappear:(BOOL)arg1;
- (void)imageSelected:(id)arg1;
- (CGRect)frameForIndex:(long long)arg1 count:(long long)arg2;
- (void)addToIdleContentImageViewAry:(id)arg1;
- (id)dequeueReusableImageView;
- (id)imageViewForImageURL:(id)arg1 reusing:(BOOL)arg2;
- (id)imageViewForImageURL:(id)arg1;
- (void)reloadImageViews;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)setHidden:(BOOL)arg1;
@end

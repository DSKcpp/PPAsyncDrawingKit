//
//  PPTextContentView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"

@class WBTimelineTextRenderer;
@class WBTimelineLargeCardView;
@class PPTextRenderer;
@class WBTimelineTableViewCellDrawingContext;
@class PPTextContentView;

@protocol PPTextContentViewDelegate <NSObject>
@optional
- (void)customSourceControlFrame:(CGRect)frame;
- (void)textContentViewTopRightButtonWidthDidChange:(PPTextContentView *)textContextView;
- (CGFloat)topRightButtonWidth;
- (void)textContentViewDidFinishDrawing:(PPTextContentView *)textContextView asynchronously:(BOOL)asynchronously;
- (void)didPressShowPictures:(NSArray *)arg1 inView:(UIView *)arg2;
- (void)didPressOtherTouchableItem:(NSUInteger)arg1 params:(NSDictionary *)params;
- (void)didLongPressOtherTouchableItem:(NSUInteger)arg1;
- (void)didPressTitleName:(NSString *)arg1;
- (void)didPressTopicName:(NSString *)arg1;
- (void)didPressUrlLink:(NSURL *)arg1;
- (void)didPressUserName:(NSString *)arg1;
- (void)didPressUserScreenNameLabel:(id)arg1;
@end

@interface PPTextContentView : PPAsyncDrawingView
@property (nonatomic, strong) NSMutableArray *attachmentViews;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, assign) NSUInteger touchingItemIndex;
@property (nonatomic, assign) CGRect unionAreaHighlightedFeedbackFrame;
@property (nonatomic, assign) CGFloat detaRightPading;
@property (nonatomic, assign) CGFloat timeSourceReleventWidth;
@property (nonatomic, assign) BOOL isSourceRectBeReset;
@property (nonatomic, assign) BOOL customSourceColorDefault;
@property (nonatomic, strong) NSMutableArray *wb_accessibilityElements;
@property (nonatomic, strong) WBTimelineTextRenderer *metaInfoTextRenderer;
@property (nonatomic, assign) BOOL quotedItemHighlighted;
@property (nonatomic, strong) NSMutableAttributedString *sourceInfoString;
@property (nonatomic, strong) WBTimelineLargeCardView *largeCardView;
@property (nonatomic, assign) BOOL disableTextLinkHighlight;
@property (nonatomic, strong) PPTextRenderer *respondTextRenderer;
@property (nonatomic, strong) WBTimelineTextRenderer *titleTextRenderer;
@property (nonatomic, strong) WBTimelineTextRenderer *quotedItemTextRenderer;
@property (nonatomic, strong) WBTimelineTextRenderer *itemTextRenderer;
@property (nonatomic, weak) id <PPTextContentViewDelegate> delegate;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) WBTimelineTableViewCellDrawingContext *drawingContext;
@end

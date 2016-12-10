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
#import "PPIsomerismTextView.h"
#import "PPImageView.h"

@interface WBTimelineLargeCardTextView : PPIsomerismTextView
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;
@property (nonatomic, strong) PPTextRenderer *titleRenderer;
@property (nonatomic, strong) PPTextRenderer *descRenderer;
@end

@interface WBPageInfoBaseCardView : UIView
@property (nonatomic, strong) PPImageView *imageView;
@property (nonatomic, strong) WBTimelineLargeCardTextView *textView;

+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type;
+ (CGFloat)heightConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type;
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
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, weak) id<WBTimelineLargeCardViewDelegate> delegate;
@property (nonatomic, strong) WBTimelinePageInfo *pageInfo;

- (id)previewingContext:(id)arg1 viewControllerForLocation:(CGPoint)arg2;
- (id)mediaParametersForType:(id)arg1;
- (void)didPressVideoCard;
- (void)didPressCardView:(id)arg1 pageURL:(id)arg2;
- (void)setHighlighted:(BOOL)arg1;
- (id)pageInfoIdentifier;

- (void)commonButtonView:(id)arg1 handleCommonButtonModelMayBeChanged:(id)arg2;
- (void)updateViewWithPageInfo:(id)arg1;
- (void)loadWithTimelineItem:(id)arg1;
- (void)loadWithPageInfo:(id)arg1 forPageID:(id)arg2;
- (void)_updateCardViewClassWithPageInfo:(id)arg1;
- (void)setButtonParaDict:(id)arg1;
- (instancetype)initWithFrame:(CGRect)frame;
@end



//
//  WBTimelineTableViewCellDrawingContext.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPAttributedText;
@class WBTimelineItem;

@interface WBTimelineTableViewCellDrawingContext : NSObject
@property (nonatomic, assign) unsigned long long renderVersion;
@property(retain) NSString *uniqueIdentifier;
@property (nonatomic, assign) CGRect displaySourceFromFrame;
@property (nonatomic, assign) CGRect retweetedLongStatusRequestStateAreaFrame;
@property (nonatomic, assign) CGRect longStatusRequestStateAreaFrame;
@property (nonatomic, assign) CGRect miniCardGroupFrame;
@property (nonatomic, assign) CGSize displayNameSize;
//@property(retain) WBTimelineContentImageViewLayouter *imageLayouter;
@property (nonatomic, assign) int topRightButtonType;
@property (nonatomic, assign) CGRect productsFrame;
@property BOOL showPictureTag;
@property (nonatomic, assign) BOOL isNotCustomSource;
@property (nonatomic, assign) CGRect quotedItemContinueIndicatorFrame;
@property (nonatomic, assign) CGRect continueIndicatorFrame;
@property (nonatomic, assign) CGRect lastSourceInfoTextFrame;
@property (nonatomic, assign) CGRect quotedImageTagFrame;
@property (nonatomic, assign) CGRect quotedVideoFrame;
@property (nonatomic, assign) CGRect videoFrame;
@property (nonatomic, assign) CGRect mapFrame;
@property (nonatomic, assign) CGRect largeCardFrame;
@property (nonatomic, assign) unsigned long long topLineLeftWidth;
@property (nonatomic, assign) unsigned long long topLineRightWidth;
@property (nonatomic, assign) CGFloat titleSectionHeight;
@property (nonatomic, assign) CGRect titleItemTextFrame;
@property (nonatomic, assign) CGRect quotedItemTextFrame;
@property (nonatomic, assign) CGRect quotedItemFalseInfoTextFrame;
@property (nonatomic, assign) CGRect quotedItemFalseInfoBackgroundImageFrame;
@property (nonatomic, assign) CGRect quotedItemContentBorderImageFrame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect itemTextFrame;
@property (nonatomic, assign) CGRect titleTextFrame;
@property (nonatomic, assign) CGRect falseInfoTextFrame;
@property (nonatomic, assign) CGRect falseInfoBackgroundImageFrame;
@property (nonatomic, assign) BOOL screenNameLabelShowUserRemark;
@property (nonatomic, assign) CGRect screenNameFrame;
@property(retain, nonatomic) NSMutableDictionary *userInfo;
@property(retain, nonatomic) PPAttributedText *titleItemAttributedText;
@property(retain, nonatomic) PPAttributedText *quotedItemAttributedText;
@property(retain, nonatomic) PPAttributedText *itemAttributedText;
@property(retain, nonatomic) NSString *quotedItemFalseInfoText;
@property(retain, nonatomic) NSString *itemFalseInfoText;
@property(readonly, nonatomic) NSString *titleItemText;
@property(readonly, nonatomic) NSString *briefQuotedItemText;
@property(readonly, nonatomic) NSString *briefItemText;
@property(readonly, nonatomic) NSString *displayName;
@property(retain, nonatomic) UIColor *imageMaskColor;
@property (nonatomic, assign) CGRect rectOfPhotoImageLayer;
@property (nonatomic, assign) CGRect rectOfPhotoImage;
@property (nonatomic, assign) CGSize quotedItemTextSize;
@property (nonatomic, assign) CGSize itemTextSize;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, weak) WBTimelineItem *timelineItem;
@property (nonatomic, assign) CGRect commentSummaryFrame;
@property (nonatomic, assign) CGRect forwardSummaryFrame;
@property (nonatomic, assign) CGRect likeSummaryFrame;
@property(retain, nonatomic) PPAttributedText *commentCountSummaryAttributedText;
@property (nonatomic, assign) CGRect commentCountSummaryAttributedTextFrame;
@property(retain, nonatomic) NSArray *commentSummaryAttributedTextFrameArray;
@property(retain, nonatomic) NSArray *commentSummaryAttributedTextArray;
@property (nonatomic, assign) CGRect commmentSummaryIconFrame;
@property (nonatomic, assign) CGRect forwardSummaryAttributedTextFrame;
@property(retain, nonatomic) NSArray *forwardSummaryAttributedTextFrameArray;
@property(retain, nonatomic) NSArray *forwardSummaryAttributedTextArray;
@property (nonatomic, assign) CGRect forwardSummaryIconFrame;
@property(retain, nonatomic) PPAttributedText *forwardSummaryAttributedText;
@property (nonatomic, assign) CGRect likeSummaryAttributedTextFrame;
@property (nonatomic, assign) CGRect likeSummaryIconFrame;
@property(retain, nonatomic) PPAttributedText *likeSummaryAttributedText;
@property (nonatomic, assign) long long specialBackgroundType;
@property(retain, nonatomic) NSArray *recentCommentAttributedTexts;
@property(retain, nonatomic) NSArray *recentCommentTextFrames;
@property (nonatomic, assign) CGRect recentCommentsFrame;
@property (nonatomic, assign) CGRect likeButtonFrame;
@property (nonatomic, assign) CGRect timeTextFrame;

- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem;
- (void)resetWithContentWidth:(CGFloat)width;
- (void)resetWithContentWidth:(CGFloat)width userInfo:(NSDictionary *)userInfo;
- (void)resetTimelineItem:(WBTimelineItem *)timelineItem;
- (unsigned long long)getContextVersion;
- (void)setContextVersion:(unsigned long long)arg1;
- (id)availableImageURLs;
- (id)availableImageURL;
- (id)availableThumbnailImageURL;
- (id)availableMiddleImageURL;
- (BOOL)shouldShowLocationIndicator;
- (BOOL)shouldShowImageIndicator;
- (BOOL)shouldHighlightTimeText;
- (BOOL)shouldShowImage;
- (BOOL)hasLocation;
- (BOOL)shouldShowTime;
- (id)quotedImages;
- (BOOL)quotedItemHasPhoto;
- (id)images;
- (BOOL)itemHasPhoto;
- (id)quotedProducts;
- (BOOL)quotedItemHasProduct;
- (id)products;
- (BOOL)itemHasProduct;
- (BOOL)shouldShowAvatar;
- (BOOL)shouldShowSource;
- (BOOL)shouldShowExtraActionButton;
- (BOOL)isValid;
- (void)generateTitleItemText;
- (void)generateBriefQuotedItemText;
- (void)generateBriefItemText;
- (id)flagImageUrl;
- (id)statusTypeTextColors;
- (id)statusTypeTexts;

@end

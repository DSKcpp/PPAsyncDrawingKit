//
//  WBTimelineItem.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WBCardModel;
@class WBTimelineItem;
@class WBUser;
@class WBCardUserBadge;
@class WBPictureMetadata;
@class WBTimelinePicture;
@class WBTimelineTableViewCellDrawingContext;
@class WBTimelineTitle;

@interface WBCardsModel : NSObject
@property (nonatomic, strong) NSArray<WBCardModel *> *cards;
@end

@interface WBCardModel : NSObject
@property (nonatomic, assign) NSUInteger card_type;
@property (nonatomic, copy) NSString *itemid;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, assign) NSUInteger show_type;
@property (nonatomic, copy) NSString *openurl;
@property (nonatomic, strong) WBTimelineItem *mblog;
@end

@interface WBTimelineItem : NSObject
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSUInteger textLength;
@property (nonatomic, assign) NSUInteger source_allowclick;
@property (nonatomic, assign) NSUInteger  source_type;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) NSUInteger appid;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, copy) NSString *in_reply_to_status_id;
@property (nonatomic, copy) NSString *in_reply_to_user_id;
@property (nonatomic, copy) NSString *in_reply_to_screen_name;
@property (nonatomic, strong) NSArray<NSString *> *pic_ids;
@property (nonatomic, copy) NSString *bmiddle_pic;
@property (nonatomic, copy) NSString *original_pic;
@property (nonatomic, copy) NSString *geo;
@property (nonatomic, strong) WBUser *user;
@property (nonatomic, assign) NSInteger reposts_count;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger attitudes_count;
@property (nonatomic, assign) BOOL isLongText;
@property (nonatomic, strong) WBTimelineItem *retweeted_status;
@property (nonatomic, strong) NSDictionary<NSString *, WBTimelinePicture *> *pic_infos;
@property (nonatomic, strong) WBTimelineTitle *title;
@property (nonatomic, strong) WBTimelineTableViewCellDrawingContext *drawingContext;

- (BOOL)showsReadCount;
- (id)accessibilityQuotedItemValue;
- (id)accessibilityItemValue;
- (id)actionButtonTypes;
- (id)readableTimeText;
- (BOOL)isShowTime;
- (id)displayTimeLineTimeTextWithColor:(CGColorRef)arg1;
- (NSString *)displayTimeText;
- (id)displayTimeTextWithTextColor:(CGColorRef)arg1;
- (id)displayTopRightCommonButton;
- (id)displaySourceScheme;
- (NSString *)displaySourceWithFrom;
- (NSString *)displaySource;
- (BOOL)shouldShowProducts;
- (BOOL)shouldShowQuotedItemProducts;
- (BOOL)shouldShowItemProducts;
- (BOOL)shouldShowImageIndicator;
- (BOOL)shouldShowImages;
- (BOOL)shouldShowQuotedItemImages;
- (BOOL)shouldShowItemImages;
- (BOOL)showQuotedVideo;
- (BOOL)showVideo;
- (BOOL)shouldShowItemTypes;
- (BOOL)shouldShowSourceText;
- (BOOL)shouldShowMapImage;
- (BOOL)shouldShowQuotedItemActionButtons;
- (BOOL)shouldShowActionButtons;
- (id)prepareDrawingContextWithUserInfo:(id)arg1;
- (id)prepareDrawingContext;
- (id)reusableCellOfTableView:(id)arg1;
- (void)didSelectRowOfTableView:(id)arg1 inViewController:(id)arg2;
+ (void)load;
- (id)uniqueDrawingContextIdentifier;
- (void)wbt_dealloc;
@end

@interface WBUser : NSObject
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic, assign) NSUInteger class;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *profile_url;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, copy) NSString *avatar_hd;
@property (nonatomic, assign) NSInteger verified_state;
@property (nonatomic, assign) NSInteger verified_level;
@property (nonatomic, assign) NSInteger verified_type_ext;
@property (nonatomic, copy) NSString *verified_reason_modified;
@property (nonatomic, copy) NSString *verified_contact_name;
@property (nonatomic, copy) NSString *verified_contact_email;
@property (nonatomic, copy) NSString *verified_contact_mobile;
@property (nonatomic, assign) BOOL follow_me;
@property (nonatomic, assign) NSInteger online_status;
@property (nonatomic, assign) NSInteger bi_followers_count;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger mbtype;
@property (nonatomic, assign) NSInteger mbrank;
@property (nonatomic, assign) NSInteger block_word;
@property (nonatomic, assign) NSInteger block_app;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ulevel;
@property (nonatomic, copy) NSString *badge_top;
@property (nonatomic, assign) NSInteger has_ability_tag;
@end

@interface WBTimelinePicture : NSObject
@property (nonatomic, copy) NSString *object_id;
@property (nonatomic, copy) NSString *pic_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger *photo_tag;
@property (nonatomic, assign) NSInteger *pic_status;
@property (nonatomic, strong) WBPictureMetadata *thumbnail;
@property (nonatomic, strong) WBPictureMetadata *bmiddle;
@property (nonatomic, strong) WBPictureMetadata *middleplus;
@property (nonatomic, strong) WBPictureMetadata *large;
@property (nonatomic, strong) WBPictureMetadata *original;
@property (nonatomic, strong) WBPictureMetadata *largest;
@end

@interface WBPictureMetadata : NSObject
@property (nonatomic, assign) NSInteger cutType;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSString *url;
@end

@interface WBTimelineTitle : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger base_color;
@property (nonatomic, copy) NSString *icon_url;
@end

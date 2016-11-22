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
@class WBTimelineContentImageViewLayouter;

@interface WBTimelineTableViewCellDrawingContext : NSObject
@property (nonatomic, weak, readonly) WBTimelineItem *timelineItem;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) PPAttributedText *titleAttributedText;
@property (nonatomic, strong) PPAttributedText *metaInfoAttributedText;
@property (nonatomic, strong) PPAttributedText *textAttributedText;
@property (nonatomic, strong) PPAttributedText *quotedAttributedText;
@property (nonatomic, assign) CGRect titleBackgroundViewFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect textContentBackgroundViewFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect quotedContentBackgroundViewFrame;
@property (nonatomic, assign) CGRect quotedFrame;
@property (nonatomic, assign) CGRect actionButtonsViewFrame;
@property (nonatomic, assign) CGRect photoFrame;
@property (nonatomic, assign) CGRect nicknameFrame;
@property (nonatomic, assign) CGRect metaInfoFrame;
@property (nonatomic, assign) CGRect avatarFrame;

- (instancetype)initWithTimelineItem:(WBTimelineItem *)timelineItem;

- (BOOL)hasPhoto;
- (BOOL)hasQuoted;
- (BOOL)hasTitle;
@end

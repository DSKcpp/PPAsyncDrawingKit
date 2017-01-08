//
//  WBTimelineAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBTimelineItem.h"

typedef NS_ENUM(NSUInteger, WBTimelineHighlightType) {
    WBTimelineHighlightTypeAt,
    WBTimelineHighlightTypeURL,
    WBTimelineHighlightTypeTopic,
    WBTimelineHighlightTypeEmail,
    WBTimelineHighlightTypeSource
};

#define kWBLinkAt @"WBTimelineHighlightTypeAt"
#define kWBLinkTopic @"WBTimelineHighlightTypeTopic"

@interface WBTimelineAttributedTextParser : NSObject

@property (nonatomic, strong) WBTimelineItem *timelineItem;
+ (instancetype)textParserWithTimelineItem:(WBTimelineItem *)timelineItem;
- (BOOL)parserWithAttributedString:(NSMutableAttributedString *)attributedString;
@end

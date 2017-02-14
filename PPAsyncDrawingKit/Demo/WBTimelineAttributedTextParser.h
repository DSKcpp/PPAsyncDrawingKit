//
//  WBTimelineAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBTimelineItem.h"

typedef NS_ENUM(NSUInteger, PPAttributedTextRangeMode) {
    PPAttributedTextRangeModeNormal,
    PPAttributedTextRangeModeMention,
    PPAttributedTextRangeModeLink,
    PPAttributedTextRangeModeHashtag,
    PPAttributedTextRangeModeDollartag,
    PPAttributedTextRangeModeEmoticon,
    PPAttributedTextRangeModeDictation,
    PPAttributedTextRangeModeMiniCard,
    PPAttributedTextRangeModeEmailAdress
};

UIKIT_EXTERN NSString * const WBTimelineHighlightRangeModeMention;
UIKIT_EXTERN NSString * const WBTimelineHighlightRangeModeTopic;
UIKIT_EXTERN NSString * const WBTimelineHighlightRangeModeLink;

@interface WBTimelineAttributedTextParser : NSObject

@property (nonatomic, strong) WBTimelineItem *timelineItem;
+ (instancetype)textParserWithTimelineItem:(WBTimelineItem *)timelineItem;
- (BOOL)parserWithAttributedString:(NSMutableAttributedString *)attributedString fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;
@end

//
//  WBTimelineAttributedTextParser.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/4.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPTextAttributed.h"
#import "WBTimelineItem.h"

@interface WBTimelineAttributedTextParser : NSObject <PPTextParser>

@property (nonatomic, strong) WBTimelineItem *timelineItem;

+ (instancetype)textParserWithTimelineItem:(WBTimelineItem *)timelineItem;
@end

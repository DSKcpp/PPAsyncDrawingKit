//
//  WBTimelineImageView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/17.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView.h"

@class WBTimelineItem;

@interface WBTimelineImageView : PPImageView
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@end

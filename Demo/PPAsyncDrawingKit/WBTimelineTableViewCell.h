//
//  WBTimelineTableViewCell.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCardsModel.h"

@class WBTimelineContentView;

@interface WBTimelineTableViewCell : UITableViewCell
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong) WBTimelineContentView *timelineContentView;
@property (nonatomic, assign) CGFloat timelineContainerWidth;
+ (CGFloat)rowHeightOfDataObject:(id)arg1 tableView:(UITableView *)tableView;
@end

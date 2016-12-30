//
//  WBTimelineTableViewCell.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTimelineItem.h"
#import "WBTimelineContentView.h"
#import "PPTextHighlightRange.h"

@class WBTimelineTableViewCell;

@protocol WBTimelineTableViewCellDelegate <NSObject>
- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
@end

@interface WBTimelineTableViewCell : UITableViewCell
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong) WBTimelineContentView *timelineContentView;
@property (nonatomic, assign) CGFloat timelineContainerWidth;
@property (nonatomic, weak) id<WBTimelineTableViewCellDelegate> delegate;
@end

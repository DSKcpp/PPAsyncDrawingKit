//
//  WBTimelineTableViewCell.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTimelineItem.h"
#import "PPTextAttributes.h"

@class WBTimelineTableViewCell;
@class WBTimelineContentView;

@protocol WBTimelineTableViewCellDelegate <NSObject>
- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didPressHighlightRange:(PPTextHighlightRange *)highlightRange;
- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedAvatarView:(WBUser *)user;
- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedNameLabel:(WBUser *)user;
- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedStatus:(WBTimelineItem *)timeline;
@end

@interface WBTimelineTableViewCell : UITableViewCell
@property (nonatomic, strong) WBTimelineItem *timelineItem;
@property (nonatomic, strong, readonly) WBTimelineContentView *timelineContentView;
@property (nonatomic, weak) id<WBTimelineTableViewCellDelegate> delegate;
@end

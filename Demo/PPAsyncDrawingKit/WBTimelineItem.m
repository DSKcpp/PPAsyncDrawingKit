//
//  WBTimelineItem.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineItem.h"
#import "WBTimelineTableViewCell.h"
#import "WBTimelineLargeCardView.h"

@implementation WBCardsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cards" : [WBCardModel class]};
}

@end

@implementation WBCardModel

@end

@implementation WBTimelineItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pic_infos" : [WBTimelinePicture class],
             @"url_struct" : [WBURLStruct class]};
}
@end

@implementation WBUser

@end

@implementation WBTimelinePicture

@end

@implementation WBPictureMetadata

@end

@implementation WBTimelineTitle

@end

@implementation WBURLStruct

@end

@implementation WBTimelinePageInfo
- (Class)timelineModelViewClass
{
    Class cls = [self modelViewClass];
    return cls;
}

- (Class)modelViewClass
{
    Class cls;
    NSLog(@"%zd", _type);
    switch (_type) {
        case 0:
            cls = [WBPageInfoBaseCardView class];
            break;
            
        default:
            cls = [WBPageInfoBaseCardView class];
            break;
    }
    return cls;
}
@end

@implementation WBPageActionLog

@end

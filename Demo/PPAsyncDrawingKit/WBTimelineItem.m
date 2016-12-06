//
//  WBTimelineItem.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineItem.h"
#import "WBTimelineTableViewCell.h"

@implementation WBCardsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cards" : [WBCardModel class]};
}

@end

@implementation WBCardModel

@end

@implementation WBTimelineItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pic_infos" : [WBTimelinePicture class], @"url_struct" : [WBURLStruct class]};
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

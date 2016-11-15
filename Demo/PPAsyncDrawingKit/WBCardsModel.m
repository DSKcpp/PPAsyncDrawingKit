//
//  WBCardsModel.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBCardsModel.h"

@implementation WBCardsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cards" : [WBCardModel class]};
}
@end

@implementation WBCardModel

@end

@implementation WBTimelineItem
- (NSString *)displaySource
{
    return self.source;
}

- (NSString *)displaySourceWithFrom
{
    return [NSString stringWithFormat:@"来自 %@", self.displaySource];
}

- (NSString *)displayTimeText
{
//    NSDate *date = [NSDatef]
    return @"";
}
@end

@implementation WBUser

@end

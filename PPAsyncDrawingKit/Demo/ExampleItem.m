//
//  ExmapleItem.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "ExampleItem.h"

@implementation ExampleItem
+ (ExampleItem *)t:(NSString *)title c:(NSString *)className;
{
    ExampleItem *this = [self new];
    this.title = title;
    this.clsName = className;
    return this;
}
@end

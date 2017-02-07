//
//  ExmapleItem.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExampleItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) Class clsName;

+ (ExampleItem *)t:(NSString *)title c:(Class)className;
@end

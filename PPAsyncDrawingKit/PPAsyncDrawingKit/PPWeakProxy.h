//
//  PPWeakProxy.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/8.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPWeakProxy : NSProxy
@property (nonatomic, weak, readonly) id target;

+ (PPWeakProxy *)weakProxyWithTarget:(id)target;
@end

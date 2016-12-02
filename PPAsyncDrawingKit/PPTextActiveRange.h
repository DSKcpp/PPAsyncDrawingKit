//
//  PPTextActiveRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/28.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTextActiveRange : NSObject
@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END

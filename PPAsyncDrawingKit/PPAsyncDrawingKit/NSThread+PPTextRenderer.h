//
//  NSThread+PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPTextLayout;

@interface NSThread (PPTextRenderer)
@property (nonatomic, strong, readonly) PPTextLayout *textLayout;
@end

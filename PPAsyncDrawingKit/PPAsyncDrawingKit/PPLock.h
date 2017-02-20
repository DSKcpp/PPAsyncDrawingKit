//
//  PPLock.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/20.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPLock : NSObject <NSLocking>
- (void)lock;
- (void)unlock;
@end

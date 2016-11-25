//
//  PPFlavoredRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/28.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextRenderer.h"

@interface PPFlavoredRange : NSObject <PPTextActiveRange>
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSInteger flavor;
+ (PPFlavoredRange *)valueWithRange:(NSRange)range;
@end

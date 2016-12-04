//
//  PPFlavoredRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/28.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextActiveRange.h"

typedef NS_ENUM(NSUInteger, PPFlavoredRangeType) {
    PPFlavoredRangeTypeDefault,
    PPFlavoredRangeTypeURL,
    PPFlavoredRangeTypeEmoticon
};

@interface PPFlavoredRange : PPTextActiveRange
@property (nonatomic, assign) PPFlavoredRangeType flavor;
@end

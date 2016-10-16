//
//  PPAsyncDrawingKitUtilities.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline CFRange CFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

static inline NSRange NSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline void hex16ToFloat(int hex) {
    int i = hex;
    float *f = (float *)&i;
    printf("%f\n",*f);
}

@interface PPAsyncDrawingKitUtilities : NSObject

@end

//
//  PPImage+WebP.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/25.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImage.h"

#if __has_include(<WebP/decode.h>)

@interface PPImage (WebP)
+ (nullable UIImage *)imageWithWebPData:(nullable NSData *)data;
@end

#endif

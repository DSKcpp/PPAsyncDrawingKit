//
//  NPPata+PPImageContentType.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PPImageFormat) {
    PPImageFormatUndefined = -1,
    PPImageFormatJPEG = 0,
    PPImageFormatPNG,
    PPImageFormatGIF,
    PPImageFormatTIFF,
    PPImageFormatWebP
};

@interface NSData (PPImageContentType)
+ (PPImageFormat)pp_imageFormatForImageData:(nullable NSData *)data;
@end

//
//  NSData+PPImageContentType.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSData+PPImageContentType.h"

@implementation NSData (PPImageContentType)
+ (PPImageFormat)pp_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return PPImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return PPImageFormatJPEG;
        case 0x89:
            return PPImageFormatPNG;
        case 0x47:
            return PPImageFormatGIF;
        case 0x49:
        case 0x4D:
            return PPImageFormatTIFF;
        case 0x52:
            // R as RIFF for WEBP
            if (data.length < 12) {
                return PPImageFormatUndefined;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return PPImageFormatWebP;
            }
    }
    return PPImageFormatUndefined;
}
@end

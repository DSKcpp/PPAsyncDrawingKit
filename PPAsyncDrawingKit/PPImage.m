//
//  PPImage.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/25.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImage.h"
#import "NSData+PPImageContentType.h"
#import "PPImage+WebP.h"

@implementation PPImage
+ (UIImage *)imageWithData:(NSData *)data
{
    UIImage *image;
    PPImageFormat imageFormat = [NSData pp_imageFormatForImageData:data];
    if (imageFormat == PPImageFormatGIF) {
        //        image =
    } else if (imageFormat == PPImageFormatWebP) {
        image = [PPImage imageWithWebPData:data];
    } else {
        image = [UIImage imageWithData:data];
    }
    return image;
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self imageWithData:data];
}


@end

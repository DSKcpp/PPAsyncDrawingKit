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
        image = [PPImage animatedGIFWithData:data];
    } else if (imageFormat == PPImageFormatWebP) {
#if PPIMAGEWEBP
        image = [PPImage imageWithWebPData:data];
#endif
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

+ (UIImage *)animatedGIFWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *staticImage;
    
    if (count <= 1) {
        staticImage = [[UIImage alloc] initWithData:data];
    } else {
        // we will only retrieve the 1st frame. the full GIF support is available via the FLAnimatedImageView category.
        // this here is only code to allow drawing animated images as static ones
        CGFloat scale = 1;
        scale = [UIScreen mainScreen].scale;
        
        CGImageRef CGImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        UIImage *frameImage = [UIImage imageWithCGImage:CGImage scale:scale orientation:UIImageOrientationUp];
        staticImage = [UIImage animatedImageWithImages:@[frameImage] duration:0.0f];
        CGImageRelease(CGImage);
    }
    
    CFRelease(source);
    
    return staticImage;
}

- (BOOL)isGIF
{
    return (self.images != nil);
}
@end

//
//  PPImage.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/25.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPImageDecode : NSObject

+ (nullable UIImage *)imageWithData:(nullable NSData *)data;
+ (nullable UIImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable UIImage *)animatedGIFWithData:(nullable NSData *)data;
+ (nullable UIImage *)imageWithWebPData:(nullable NSData *)data;
+ (nullable UIImage *)decodeImageWithImage:(nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END

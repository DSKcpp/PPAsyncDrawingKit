//
//  PPImageView+WebCache.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView+WebCache.h"
#import "PPWebImageManager.h"

@implementation PPImageView (WebCache)
- (void)setImageURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage
{
    [[PPWebImageManager sharedManager] loadImage:URL complete:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@", image);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    }];
}
@end

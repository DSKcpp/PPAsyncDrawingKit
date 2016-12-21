//
//  PPImageView+WebCache.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/21.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageView.h"

@interface PPImageView (WebCache)
- (void)setImageURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage;
@end

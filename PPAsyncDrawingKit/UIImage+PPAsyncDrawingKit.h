//
//  UIImage+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PPAsyncDrawingKit)
- (CGRect)pp_convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;
- (void)pp_drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode withContext:(nullable CGContextRef)context;
@end

NS_ASSUME_NONNULL_END

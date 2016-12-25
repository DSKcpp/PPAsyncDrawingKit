//
//  PPImage.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/25.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPImage : UIImage
@property (nonatomic, assign ,readonly) BOOL isWebP;
@end

NS_ASSUME_NONNULL_END

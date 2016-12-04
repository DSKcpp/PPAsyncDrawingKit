//
//  WBEmoticonManager.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/3.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBEmoticonManager : NSObject
@property (strong, class, readonly) WBEmoticonManager *sharedMangaer;
@property (nonatomic, strong, readonly) NSDictionary *config;

- (nullable UIImage *)imageWithEmotionName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END

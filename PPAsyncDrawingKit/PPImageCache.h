//
//  PPImageCache.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PPImageCacheType) {
    PPImageCacheTypeNone,
    PPImageCacheTypeDisk,
    PPImageCacheTypeMemory,
    PPImageCacheTypeAll
};

NS_ASSUME_NONNULL_BEGIN

@interface PPImageCache : NSObject
@property (nonatomic, class, strong, readonly) PPImageCache *sharedCache;
@property (nonatomic, assign) NSUInteger maxMemorySize;
@property (nonatomic, assign) NSUInteger maxCacheSize;
@property (nonatomic, assign) CGFloat maxCacheAge;
@property (nonatomic, copy, readonly) NSString *cachePath;

- (nullable NSString *)keyWithURL:(NSString *)URL;
- (NSString *)cachePathForKey:(NSString *)key;

- (nullable UIImage *)imageForURL:(NSString *)URL;
- (nullable UIImage *)imageForURL:(NSString *)URL taskKey:(nullable NSString *)taskKey;
- (nullable UIImage *)imageFromMemoryCacheForURL:(NSString *)URL;
- (nullable UIImage *)imageFromDiskCacheForURL:(NSString *)URL;
- (void)imageForURL:(NSString *)URL callback:(void(^)(UIImage * _Nullable image, PPImageCacheType cacheType))callback;

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL;
- (void)storeImage:(nullable UIImage *)image data:(nullable NSData *)data forURL:(NSString *)URL toDisk:(BOOL)toDisk;
- (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL;

- (BOOL)imageCachedForURL:(NSString *)URL;
- (BOOL)imageHasDiskCachedForURL:(NSString *)URL;

- (NSString *)diskCachePathForImageURL:(NSString *)imageURL;
- (void)addToCurrentReadingTaskKeys:(NSString *)TaskKeys;
- (void)removeFromCurrentReadingTaskKeys:(NSString *)TaskKeys;

- (NSUInteger)cacheSize;
- (void)cleanDiskCache;
- (void)cleanMemoryCache;
@end

NS_ASSUME_NONNULL_END

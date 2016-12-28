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
@property (nonatomic, strong) NSMutableArray *currentReadingTaskKeys;
@property (nonatomic, assign) NSUInteger maxMemorySize;
@property (nonatomic, assign) NSUInteger maxCacheSize;
@property (nonatomic, assign) CGFloat maxCacheAge;
@property (nonatomic, copy, readonly) NSString *cachePath;

- (NSUInteger)cacheSize;

- (void)removeRefrence:(id)arg1;
- (void)addRefrence:(id)arg1;

- (nullable NSString *)keyWithURL:(NSString *)URL;

- (nullable UIImage *)imageForURL:(NSString *)URL;
- (nullable UIImage *)imageForURL:(NSString *)URL taskKey:(nullable NSString *)taskKey;
- (void)imageForURL:(NSString *)URL callback:(void(^)(UIImage * _Nullable image, PPImageCacheType cacheType))callback;

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL;
- (void)storeImage:(nullable UIImage *)image data:(nullable NSData *)data forURL:(NSString *)URL toDisk:(BOOL)toDisk;
- (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL;

- (BOOL)imageCachedForURL:(NSString *)URL;
- (BOOL)imageHasDiskCachedForURL:(NSString *)URL;

- (NSString *)diskCachePathForImageURL:(NSString *)imageURL;
- (void)addToCurrentReadingTaskKeys:(NSString *)TaskKeys;
- (void)removeFromCurrentReadingTaskKeys:(NSString *)TaskKeys;

- (id)permenantPathForImageURL:(id)arg1;
- (id)permenantForlderPath;
- (id)tempPathForImageURL:(id)arg1;
- (id)tempForlderPath;
- (long long)checkAllFolderSize;
- (void)cleanDiskCache;
- (void)cleanMemoryCache;
@end

NS_ASSUME_NONNULL_END

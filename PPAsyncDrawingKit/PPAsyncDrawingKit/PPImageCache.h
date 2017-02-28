//
//  PPImageCache.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPImageTask.h"

typedef NS_ENUM(NSUInteger, PPImageCacheType) {
    PPImageCacheTypeNone,
    PPImageCacheTypeDisk,
    PPImageCacheTypeMemory,
    PPImageCacheTypeAll
};

NS_ASSUME_NONNULL_BEGIN

/**
 图片缓存模块
 */
@interface PPImageCache : NSObject
@property (nonatomic, class, strong, readonly) PPImageCache *sharedCache;

/**
 最大内存缓存大小 bytes
 */
@property (nonatomic, assign) NSUInteger maxMemoryCacheSize;

/**
 最大磁盘缓存大小 bytes
 */
@property (nonatomic, assign) NSUInteger maxDiskCacheSize;

/**
 文件在磁盘中保留的时间 second
 */
@property (nonatomic, assign) CGFloat maxCacheAge;

/**
 缓存路径
 */
@property (nonatomic, copy, readonly) NSString *cachePath;

/**
 从磁盘缓存中获取文件的任务
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, PPImageIOTask *> *ioTasks;

/**
 根据URL返回 key

 @param URL 图片URL
 @return 返回 URL -> MD5
 */
- (nullable NSString *)keyWithURL:(NSString *)URL;

/**
 根据Key返回磁盘缓存路径

 @param key key
 @return 磁盘缓存路径
 */
- (NSString *)cachePathForKey:(NSString *)key;

/**
 根据URL返回磁盘缓存路径
 
 @param imageURL 图片URL
 @return 磁盘缓存路径
 */
- (NSString *)diskCachePathForImageURL:(NSString *)imageURL;

/**
 根据URL使用当前线程获取图片

 @param URL 图片URL
 @return 图片
 */
- (nullable UIImage *)imageForURL:(NSString *)URL;

/**
 根据URL使用当前线程从内存缓存中获取图片

 @param URL 图片URL
 @return 图片
 */
- (nullable UIImage *)imageFromMemoryCacheForURL:(NSString *)URL;

/**
 根据URL使用当前线程从磁盘缓存中获取图片

 @param URL 图片URL
 @return 图片
 */
- (nullable UIImage *)imageFromDiskCacheForURL:(NSString *)URL;

/**
 根据图片URL获取图片，若在内存缓存中获取不到，将使用内置的IO线程从磁盘缓存获取

 @param URL 图片URL
 @param callback image 图片，cacheType 来自哪一个缓存
 @return 获取图片的IO任务，如果图片来自内存缓存，则是 nil
 */
- (nullable PPImageIOTask *)imageForURL:(NSString *)URL callback:(void(^)(UIImage * _Nullable image, PPImageCacheType cacheType))callback;

/**
 在当前线程保存图片到内存缓存

 @param image 图片
 @param URL 图片URL
 */
- (void)storeImage:(UIImage *)image forURL:(NSString *)URL;

/**
 保存图片到缓存，如果需要保存到磁盘缓存，将使用内置的IO线程保存到磁盘

 @param image 图片
 @param data 图片数据
 @param URL 图片的URL
 @param toDisk 是否需要同时保存到磁盘缓存
 */
- (void)storeImage:(nullable UIImage *)image data:(nullable NSData *)data forURL:(NSString *)URL toDisk:(BOOL)toDisk;

/**
 使用内置的IO线程保存图片到磁盘缓存

 @param imageData 图片数据
 @param URL 图片URL
 */
- (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL;

/**
 根据图片URL判断内存缓存中是否有这张图片

 @param URL 图片URL
 @return yes or no
 */
- (BOOL)imageCachedForURL:(NSString *)URL;

/**
 根据图片URL判断磁盘缓存中是否有这张图片

 @param URL 图片URL
 @return yes or no
 */
- (BOOL)imageHasDiskCachedForURL:(NSString *)URL;

/**
 本地磁盘缓存文件总大小

 @return bytes
 */
- (NSUInteger)diskCacheSize;

/**
 清除磁盘缓存
 */
- (void)cleanDiskCache;

/**
 删除旧文件，根据 maxCacheAge
 */
- (void)cleanOldFile;

/**
 清除内存缓存
 */
- (void)cleanMemoryCache;

/**
 根据URL获取IO任务

 @param URL 图片URL
 @return IO任务
 */
- (PPImageIOTask *)fetchIOTaskWithURL:(NSString *)URL;

/**
 取消IO任务

 @param IOTask 需要取消的IO任务
 */
- (void)cancelImageIOWithTask:(PPImageIOTask *)IOTask;
@end

NS_ASSUME_NONNULL_END

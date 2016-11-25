//
//  PPImageCache.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, PPImageCacheType) {
    PPImageCacheTypeDisk = 1 << 0,
    PPImageCacheTypeMemory = 1 << 1
};

NS_ASSUME_NONNULL_BEGIN

@interface PPImageCache : NSObject
@property (class, strong, readonly) PPImageCache *sharedCache;
@property (nonatomic, strong) NSRecursiveLock *readingTaskLock;
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
- (nullable UIImage *)imageForURL:(NSString *)URL storageType:(NSInteger)storageType;
- (nullable UIImage *)imageForURL:(NSString *)URL storageType:(NSInteger)storageType taskKey:(id)taskKey;
- (nullable UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent;
- (nullable UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent storageType:(NSUInteger)storageType;
- (nullable UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent storageType:(NSUInteger)storageType taskKey:(id)taskKey;

- (void)cacheImage:(UIImage *)image forURL:(NSString *)URL;
- (void)cacheImage:(UIImage *)image data:(nullable NSData *)data forURL:(NSString *)URL cacheType:(PPImageCacheType)cacheType;
- (void)cacheImage:(UIImage *)image data:(nullable NSData *)data forURL:(NSString *)URL cacheType:(PPImageCacheType)cacheType storageType:(NSInteger)storageType;
- (void)cacheImageData:(NSData *)data forURL:(NSString *)URL;
- (void)cacheImageData:(NSData *)data forURL:(NSString *)URL storageType:(NSInteger)storageType;

- (BOOL)imageHasDiskCachedForURL:(NSString *)URL;
- (BOOL)imageCachedForURL:(NSString *)URL;
- (BOOL)imageCachedForURL:(NSString *)URL type:(NSInteger)type;

- (void)imageForURL:(id)arg1 callback:(void(^)(void))arg2;
- (id)diskCachePathForImageURL:(id)arg1 withType:(long long)arg2;
- (id)diskCachePathForImageURL:(id)arg1;
- (NSString *)folderPath:(long long)arg1;
- (void)removeFromCurrentReadingTaskKeys:(id)arg1;
- (void)addToCurrentReadingTaskKeys:(id)arg1;


- (id)permenantPathForImageURL:(id)arg1;
- (id)permenantForlderPath;
- (id)tempPathForImageURL:(id)arg1;
- (id)tempForlderPath;
- (long long)checkAllFolderSize;
- (id)getCachePathsWithType:(long long)arg1 withTemp:(BOOL)arg2;
- (void)cleanDiskForce;
- (void)removeDiskCachesAuto:(long long)arg1;
- (void)cleanDiskCache:(BOOL)arg1;
- (void)clearDisk;
- (void)cleanMemoryCache;
- (void)receiveMemoryWarning:(NSNotification *)notification;
- (void)checkAndAutoClean;
@end

NS_ASSUME_NONNULL_END

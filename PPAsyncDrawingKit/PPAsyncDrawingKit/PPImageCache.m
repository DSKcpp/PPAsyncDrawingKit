//
//  PPImageCache.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageCache.h"
#import <CommonCrypto/CommonCrypto.h>
#import "PPImageDecode.h"
#import "PPLock.h"

#define kPPImageCacheMaxAge 604800.0f // 7 day
#define kPPImageCacheMaxMemorySize 209715200 // 200 MB
#define kPPImageCacheMaxSize 209715200 // 200 MB

static NSString *_PPNSStringMD5(NSString *string) {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@interface PPImageCache ()
{
    NSCache<NSString *, UIImage *> *_cache;
    dispatch_queue_t _ioQueue;
    PPLock *_lock;
}
@end

@implementation PPImageCache
+ (PPImageCache *)sharedCache
{
    static PPImageCache *_sharedCache;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedCache = [[self alloc] init];
    });
    return _sharedCache;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *name = @"io.github.dskcpp.PPAsyncDrawingKit.imageCache";
        _cache = [[NSCache alloc] init];
        _cache.name = name;
        _maxCacheAge = kPPImageCacheMaxAge;
        _maxDiskCacheSize = kPPImageCacheMaxSize;
        self.maxMemoryCacheSize = kPPImageCacheMaxMemorySize;
        
        _ioTasks = @{}.mutableCopy;
        _lock = [[PPLock alloc] init];
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        cachePath = [cachePath stringByAppendingPathComponent:@"PPImageCache"];
        _cachePath = cachePath;
        
        _ioQueue = dispatch_queue_create("io.github.dskcpp.PPAsyncDrawingKit.imageCache.ioQueue", DISPATCH_QUEUE_SERIAL);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:_cachePath]) {
            [fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanOldFile)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)setMaxMemoryCacheSize:(NSUInteger)maxMemoryCacheSize
{
    if (_maxMemoryCacheSize != maxMemoryCacheSize) {
        _maxMemoryCacheSize = maxMemoryCacheSize;
        _cache.totalCostLimit = maxMemoryCacheSize;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveMemoryWarning:(NSNotification *)notification
{
    [self cleanMemoryCache];
}

- (NSString *)keyWithURL:(NSString *)URL
{
    if (URL.length) {
        return _PPNSStringMD5(URL);
    }
    return nil;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    return [_cachePath stringByAppendingPathComponent:key];
}

- (UIImage *)imageForURL:(NSString *)URL
{
    if (!URL) {
        return nil;
    }
    
    BOOL cache = [self imageCachedForURL:URL];
    if (cache) {
        NSString *key = [self keyWithURL:URL];
        UIImage *image = [_cache objectForKey:key];
        if (!image) {
            image = [PPImageDecode imageWithContentsOfFile:[self cachePathForKey:key]];
        }
        return image;
    }
    return nil;
}

- (UIImage *)imageFromMemoryCacheForURL:(NSString *)URL
{
    NSString *key = [self keyWithURL:URL];
    return [_cache objectForKey:key];
}

- (UIImage *)imageFromDiskCacheForURL:(NSString *)URL
{
    NSString *key = [self keyWithURL:URL];
    return [PPImageDecode imageWithContentsOfFile:[self cachePathForKey:key]];
}

- (PPImageIOTask *)imageForURL:(NSString *)URL callback:(nonnull void (^)(UIImage * _Nullable, PPImageCacheType))callback
{
    if (!callback) {
        return nil;
    }
    
    UIImage *image = [self imageFromMemoryCacheForURL:URL];
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(image, PPImageCacheTypeMemory);
        });
    } else {
        PPImageIOTask *task = [PPImageIOTask taskForURL:URL];
        dispatch_async(_ioQueue, ^{
            if (task.isCancelled) {
                return;
            }
            UIImage *image = [self imageFromDiskCacheForURL:URL];
            if (image) {
                [self storeImage:image forURL:URL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(image, PPImageCacheTypeDisk);
            });
        });
        return task;
    }
    return nil;
}

- (BOOL)imageCachedForURL:(NSString *)URL
{
    if ([self imageFromMemoryCacheForURL:URL]) {
        return YES;
    } else {
        return [self imageHasDiskCachedForURL:URL];
    }
}

- (BOOL)imageHasDiskCachedForURL:(NSString *)URL
{
    NSString *key = [self keyWithURL:URL];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self cachePathForKey:key]];
}

- (NSString *)diskCachePathForImageURL:(NSString *)imageURL
{
    return [self cachePathForKey:[self keyWithURL:imageURL]];
}

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL
{
    if (!image || !URL) {
        return;
    }
    NSString *key = [self keyWithURL:URL];
    NSUInteger cost = image.size.height * image.size.width;
    if (cost <= 1024 * 1024) {
        [_cache setObject:image forKey:key cost:cost];
    }
}

- (void)storeImage:(UIImage *)image data:(NSData *)data forURL:(NSString *)URL toDisk:(BOOL)toDisk
{
    if (!URL) {
        return;
    }
    
    if (image) {
        [self storeImage:image forURL:URL];
    }
    if (toDisk) {
        NSData *_data = data;
        if (_data == nil) {
            if (!image) {
                return;
            }
            _data = UIImageJPEGRepresentation(image, 1.0);
        }
        dispatch_async(_ioQueue, ^{
            [self storeImageDataToDisk:_data forURL:URL];
        });
    }
}

- (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL;
{
    if (!imageData || !URL) {
        return;
    }

    dispatch_async(_ioQueue, ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *path = _cachePath;
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        path = [self cachePathForKey:[self keyWithURL:URL]];
        [fileManager createFileAtPath:path contents:imageData attributes:nil];
    });
}

- (NSUInteger)diskCacheSize
{
    __block NSUInteger totalCacheSize = 0;
    dispatch_sync(_ioQueue, ^{
        NSDirectoryEnumerator<NSString *> *files = [[NSFileManager defaultManager] enumeratorAtPath:_cachePath];
        for (NSString *fileName in files) {
            NSString *filePath = [self cachePathForKey:fileName];
            NSDictionary<NSFileAttributeKey, id> * attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            totalCacheSize += [attr fileSize];
        }
    });
    return totalCacheSize;
}

- (void)cleanDiskCache
{
    dispatch_async(_ioQueue, ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:_cachePath error:nil];
        [fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    });
}

- (void)cleanOldFile
{
    dispatch_async(_ioQueue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *diskCacheURL = [NSURL fileURLWithPath:_cachePath isDirectory:YES];
        NSArray<NSString *> *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:resourceKeys
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-_maxCacheAge];
        NSMutableDictionary<NSURL *, NSDictionary<NSString *, id> *> *cacheFiles = @{}.mutableCopy;
        NSUInteger currentCacheSize = 0;
        
        NSMutableArray<NSURL *> *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSError *error;
            NSDictionary<NSString *, id> *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:&error];
            
            if (error || !resourceValues || [resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += totalAllocatedSize.unsignedIntegerValue;
            cacheFiles[fileURL] = resourceValues;
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [fileManager removeItemAtURL:fileURL error:nil];
        }
        
        if (self.maxDiskCacheSize > 0 && currentCacheSize > self.maxDiskCacheSize) {
            const NSUInteger desiredCacheSize = self.maxDiskCacheSize / 2;
            
            NSArray<NSURL *> *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                                     usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                         return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                                     }];
            
            for (NSURL *fileURL in sortedFiles) {
                if ([fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary<NSString *, id> *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= totalAllocatedSize.unsignedIntegerValue;
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
    });
}

- (void)cleanMemoryCache
{
    [_cache removeAllObjects];
}

- (PPImageIOTask *)fetchIOTaskWithURL:(NSString *)URL
{
    [_lock lock];
    PPImageIOTask *task = [PPImageCache sharedCache].ioTasks[URL];
    [_lock unlock];
    
    if (!task) {
        task = [[PPImageIOTask alloc] initWithURL:URL];
    }
    
    [_lock lock];
    [PPImageCache sharedCache].ioTasks[URL] = task;
    [_lock unlock];
    
    return task;
}

- (void)cancelImageIOWithTask:(PPImageIOTask *)IOTask
{
    [IOTask cancel];
    
    [_lock lock];
    [[PPImageCache sharedCache].ioTasks removeObjectForKey:IOTask.URL];
    [_lock unlock];
}

@end

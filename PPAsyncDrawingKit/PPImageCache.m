//
//  PPImageCache.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageCache.h"
#import <CommonCrypto/CommonCrypto.h>

#define kPPImageCacheMaxAge 604800.0f
#define kPPImageCacheMaxMemorySize 20971520

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
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) dispatch_queue_t ioQueue;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSMutableDictionary *memoryMutableDict;
@property (nonatomic, strong) NSArray *resourceKeys;
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
        self.cache = [[NSCache alloc] init];
        self.cache.name = name;
        self.maxCacheAge = kPPImageCacheMaxAge;
        self.maxMemorySize = kPPImageCacheMaxMemorySize;
        self.createDate = [NSDate date];
        self.memoryMutableDict = [NSMutableDictionary dictionaryWithCapacity:2];
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ImageCache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:_cachePath]) {
            [fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.ioQueue = dispatch_queue_create("io.github.dskcpp.PPAsyncDrawingKit.imageCache.ioQueue", nil);
        self.readingTaskLock = [[NSRecursiveLock alloc] init];
        self.currentReadingTaskKeys = [NSMutableArray array];
        self.resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLFileAllocatedSizeKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAndAutoClean) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self checkAndAutoClean];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.ioQueue = nil;
    self.cache = nil;
    self.createDate = nil;
    self.readingTaskLock = nil;
}

- (void)receiveMemoryWarning:(NSNotification *)notification
{
    
}

- (void)checkAndAutoClean
{
    
}

- (NSString *)keyWithURL:(NSString *)URL
{
    if (URL.length) {
        return _PPNSStringMD5(URL);
    }
    return nil;
}

- (UIImage *)imageForURL:(NSString *)URL
{
    return [self imageForURL:URL isPermanent:NO];
}

- (UIImage *)imageForURL:(NSString *)URL taskKey:(NSString *)taskKey
{
    return [self imageForURL:URL isPermanent:NO taskKey:taskKey];
}

- (UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent
{
    return [self imageForURL:URL isPermanent:permanent taskKey:nil];
}

- (UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent taskKey:(NSString *)taskKey
{
    [self.readingTaskLock lock];
    BOOL taskConstains = [self.currentReadingTaskKeys containsObject:taskKey];
    [self.readingTaskLock unlock];
    
    if ((!URL || taskKey) && !taskConstains) {
//        [self removeFromCurrentReadingTaskKeys:taskKey];
    }

    BOOL cache = [self imageCachedForURL:URL];
    if (cache) {
        NSString *key = [self keyWithURL:URL];
        UIImage *image = [_cache objectForKey:key];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:[_cachePath stringByAppendingPathComponent:key]];
        }
        return image;
    }
    return nil;
}

- (BOOL)imageCachedForURL:(NSString *)URL
{
    NSString *key = [self keyWithURL:URL];
    UIImage *image = [_cache objectForKey:key];
    if (image) {
        return YES;
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager fileExistsAtPath:[_cachePath stringByAppendingPathComponent:key]];
    }
}

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL
{
    if (!image || !URL) {
        return;
    }
    
    CGSize size = image.size;
    NSString *key = [self keyWithURL:URL];
    NSUInteger cost = 1;
    [_cache setObject:image forKey:key cost:cost];
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        path = [path stringByAppendingPathComponent:[self keyWithURL:URL]];
        [fileManager createFileAtPath:path contents:imageData attributes:nil];
    });
}

- (NSUInteger)cacheSize
{
    NSDirectoryEnumerator<NSString *> *files = [[NSFileManager defaultManager] enumeratorAtPath:_cachePath];
    NSUInteger totalCacheSize = 0;
    for (NSString *file in files) {
        NSDictionary<NSFileAttributeKey, id> * attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
        totalCacheSize += [attr[@"fileSize"] integerValue];
    }
    return totalCacheSize;
}

@end

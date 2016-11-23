//
//  PPImageCache.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/23.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageCache.h"
#import <CommonCrypto/CommonCrypto.h>

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
        NSString *name = [NSString stringWithFormat:@"io.github.dskcpp.PPAsyncDrawingKit.imageCache"];
        self.cache = [[NSCache alloc] init];
        self.cache.name = name;
        self.maxCacheAge = 604800.0f;
        self.maxMemorySize = 20971520;
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
    return [self imageForURL:URL storageType:0];
}

- (UIImage *)imageForURL:(NSString *)URL storageType:(NSInteger)storageType
{
    return [self imageForURL:URL isPermanent:NO storageType:storageType];
}

- (UIImage *)imageForURL:(NSString *)URL storageType:(NSInteger)storageType taskKey:(id)taskKey
{
    return [self imageForURL:URL isPermanent:NO storageType:storageType taskKey:taskKey];
}

- (UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent
{
    return [self imageForURL:URL isPermanent:permanent storageType:4];
}

- (UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent storageType:(NSUInteger)storageType
{
    return [self imageForURL:URL isPermanent:permanent storageType:storageType taskKey:nil];
}

- (UIImage *)imageForURL:(NSString *)URL isPermanent:(BOOL)permanent storageType:(NSUInteger)storageType taskKey:(id)taskKey
{
    return [[UIImage alloc] init];
}

- (void)cacheImage:(UIImage *)image forURL:(NSString *)URL
{
    CGSize size = image.size;
    NSString *key = [self keyWithURL:URL];
    NSUInteger cost = 1;
    [_cache setObject:image forKey:key cost:cost];
}

- (void)cacheImage:(UIImage *)image data:(NSData *)data forURL:(NSString *)URL cacheType:(PPImageCacheType)cacheType
{
    [self cacheImage:image data:data forURL:URL cacheType:cacheType storageType:0];
}

- (void)cacheImage:(UIImage *)image data:(NSData *)data forURL:(NSString *)URL cacheType:(PPImageCacheType)cacheType storageType:(NSInteger)storageType
{
    if (URL) {
        if (cacheType & PPImageCacheTypeMemory) {
            [self cacheImage:image forURL:URL];
        }
        if (cacheType & PPImageCacheTypeDisk) {
            NSData *_data = data;
            if (_data == nil) {
                _data = UIImageJPEGRepresentation(image, 1.0);
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self cacheImageData:_data forURL:URL storageType:storageType];
            });
        }
    }
}

- (void)cacheImageData:(NSData *)data forURL:(NSString *)URL
{
    [self cacheImageData:data forURL:URL storageType:0];
}

- (void)cacheImageData:(NSData *)data forURL:(NSString *)URL storageType:(NSInteger)storageType
{
    if (data && URL) {
        dispatch_async(_ioQueue, ^{
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *path = [self folderPath:storageType];
            if (![fileManager fileExistsAtPath:path]) {
                [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            path = [path stringByAppendingPathComponent:[self keyWithURL:URL]];
            [fileManager createFileAtPath:path contents:data attributes:nil];
        });
    }
}

- (NSUInteger)cacheSize
{
    NSDirectoryEnumerator<NSString *> *files = [[NSFileManager defaultManager] enumeratorAtPath:_cachePath];
    return 1;
}
@end

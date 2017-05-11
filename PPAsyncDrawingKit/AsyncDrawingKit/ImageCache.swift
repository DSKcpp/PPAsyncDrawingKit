//
//  ImageCache.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/2.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    let cache: NSCache<AnyObject, UIImage>
    let maxCacheAge: TimeInterval = 604800
    let maxDiskCacheSize = 209715200
    let maxMemoryCacheSize = 209715200
    
    let lock = Lock()
    
    let ioQueue = DispatchQueue(label: "io.github.dskcpp.PPAsyncDrawingKit.imageCache.ioQueue")
    
    var ioTasks: [String : ImageIOTask] = [:]
    
    let cachePath: URL
    
    private init() {
        let name = "io.github.dskcpp.PPAsyncDrawingKit.imageCache"
        cache = NSCache()
        cache.name = name
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let cacheURL = URL(fileURLWithPath: path)
        cachePath = cacheURL.appendingPathComponent("PPImageCache")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: cachePath.path) {
            do {
                try fileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarning(_:)), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cleanOldFile), name: .UIApplicationWillEnterForeground, object: nil)
    }

    @objc func receiveMemoryWarning(_ notification: Notification) {
        
    }
    
    @objc func cleanOldFile() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

struct MD5 {
    
    static func conver(_ text: String) -> String {
        return text.utf8.lazy.map({ $0 as UInt8 }).md5().toHexString()
    }
}

extension ImageCache {
    
    func key(with url: String) -> String? {
        guard url.characters.count > 0 else { return nil }
        
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
    PPAsyncExecuteInMainQueue(^{
    callback(image, PPImageCacheTypeMemory);
    });
    } else {
    PPImageIOTask *task = [PPImageIOTask taskForURL:URL];
    PPAsyncExecuteIn(_ioQueue, ^{
    if (task.isCancelled) {
    return;
    }
    UIImage *image = [self imageFromDiskCacheForURL:URL];
    image = [PPImageDecode decodeImageWithImage:image];
    if (image) {
    [self storeImage:image forURL:URL];
    }
    PPAsyncExecuteInMainQueue(^{
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
    PPAsyncExecuteIn(_ioQueue, ^{
    [self storeImageDataToDisk:_data forURL:URL];
    });
    }
    }
    
    - (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL;
    {
    if (!imageData || !URL) {
    return;
    }
    
    PPAsyncExecuteIn(_ioQueue, ^{
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
    PPSyncExecuteIn(_ioQueue, ^{
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
    PPAsyncExecuteIn(_ioQueue, ^{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:_cachePath error:nil];
    [fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    });
    }
    
    - (void)cleanOldFile
    {
    PPAsyncExecuteIn(_ioQueue, ^{
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

//}

extension ImageCache {
    
    func fetchIOTask(_ imageURL: String) -> ImageIOTask {
        lock.lock()
        let task = ioTasks[imageURL] ?? ImageIOTask(imageURL: imageURL)
        lock.unlock()
        
        lock.lock()
        ioTasks[imageURL] = task
        lock.unlock()
        
        return task
    }
    
    func cancelImageIOTask(_ ioTask: ImageIOTask) {
        ioTask.cancel()
        
        lock.lock()
        ioTasks.removeValue(forKey: ioTask.imageURL)
        lock.unlock()
    }
}

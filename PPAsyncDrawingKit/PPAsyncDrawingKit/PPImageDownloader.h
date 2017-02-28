//
//  PPImageDownloader.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/17.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPImageTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPImageDownloader : NSObject
@property (nonatomic, class, strong, readonly) PPImageDownloader *sharedImageDownloader;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, PPImageDownloaderTask *> *downloaderTasks;

- (PPImageDownloaderTask *)downloaderImageWithURL:(NSURL *)URL
                                 downloadProgress:(nullable PPImageDownloaderProgress)downloadProgress
                                       completion:(PPImageDownloaderCompletion)completion;

- (PPImageDownloaderTask *)fetchDownloaderTaskWithURL:(NSString *)URL;
- (void)cancelImageDownloaderWithTask:(PPImageDownloaderTask *)downloaderTask;
@end

NS_ASSUME_NONNULL_END

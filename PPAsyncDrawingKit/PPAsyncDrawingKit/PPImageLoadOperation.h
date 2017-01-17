//
//  PPImageLoadOperation.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPImageLoadOperation;

NS_ASSUME_NONNULL_BEGIN

@protocol PPImageLoadOperationDelegate <NSObject>
- (NSString *)pathOfFileForOperation:(PPImageLoadOperation *)imageLoadOperation;
- (void)imageLoadCompleted:(PPImageLoadOperation *)imageLoadOperation
                     image:(nullable UIImage *)image
                      data:(nullable NSData *)data
                     error:(nullable NSError *)error
                   isCache:(BOOL)isCache;

@optional
- (void)replaceOperationCurrentRequestBeforeStart:(NSMutableURLRequest *)URLRequest;
- (void)imageLoadOperation:(PPImageLoadOperation *)imageLoadOperation didReceivedSize:(int64_t)receivedSize expectedSize:(int64_t)expectedSize;
- (BOOL)imageLoadOperationShouldHandleProgressImage:(PPImageLoadOperation *)imageLoadOperation;
- (NSString *)permenantPathOfFileForOperation:(PPImageLoadOperation *)imageLoadOperation;

@end

@interface PPImageLoadOperation : NSOperation
@property (nonatomic, strong) NSDictionary *requestHttpHeaders;
@property (nonatomic, strong) NSDictionary *responseHttpHeaders;
@property (nonatomic, strong, readonly) NSMutableURLRequest *URLRequest;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, weak) id<PPImageLoadOperationDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nullable, nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

+ (instancetype)operationWithURL:(NSString *)URL;
+ (NSThread *)networkRequestThread;
+ (void)networkRequestThreadEntryPoint;

- (instancetype)initWithURL:(NSString *)URL;
- (void)connectionDidStart;
- (void)reloadConnection;
@end

NS_ASSUME_NONNULL_END

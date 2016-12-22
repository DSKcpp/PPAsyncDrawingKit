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
- (NSString *)pathOfTemFileForOperation:(PPImageLoadOperation *)imageLoadOperation;
- (void)imageLoadCompleted:(PPImageLoadOperation *)imageLoadOperation
                     image:(nullable UIImage *)image
                      data:(nullable NSData *)data
                     error:(nullable NSError *)error
                   isCache:(BOOL)isCache;

@optional
- (void)replaceOperationCurrentRequestBeforeStart:(NSMutableURLRequest *)arg1;
- (void)imageLoadOperation:(PPImageLoadOperation *)imageLoadOperation didReceivedSize:(NSUInteger)receivedSize expectedSize:(NSUInteger)expectedSize;
- (BOOL)imageLoadOperationShouldHandleProgressImage:(PPImageLoadOperation *)arg1;
- (NSString *)permenantPathOfFileForOperation:(PPImageLoadOperation *)imageLoadOperation;

@end

@interface PPImageLoadOperation : NSOperation
@property(retain, nonatomic) NSOutputStream *outStream;
@property(nonatomic) long long loadedSize;
@property(nonatomic) BOOL isPermenant;
@property(nonatomic) float minNotifiProgressInterval;
@property(readonly, nonatomic) float progress;
@property(retain, nonatomic) NSDictionary *requestHttpHeaders;
@property(retain, nonatomic) NSDictionary *responseHttpHeaders;
@property(nonatomic) long long expectedSize;
//@property(nonatomic, assign, readonly, getter=isFinished) BOOL finished;
//@property(nonatomic, assign, readonly, getter=isExecuting) BOOL executing;
@property(retain, nonatomic) NSURLConnection *connection;
@property(nonatomic, weak) id<PPImageLoadOperationDelegate> delegate;
@property(readonly, copy, nonatomic) NSString *imageURL;

+ (instancetype)operationWithURL:(NSString *)URL;
+ (NSThread *)networkRequestThread;
+ (void)networkRequestThreadEntryPoint;

- (instancetype)initWithURL:(NSString *)URL;

- (void)postLogWithImageSize:(long long)arg1 isSuccess:(BOOL)arg2 error:(id)arg3;
- (struct __SecTrust *)changeHostForTrust:(struct __SecTrust *)arg1 hostName:(struct __CFString *)arg2;
- (void)connection:(id)arg1 willSendRequestForAuthenticationChallenge:(id)arg2;
- (id)connection:(id)arg1 willCacheResponse:(id)arg2;
- (void)connection:(id)arg1 didFailWithError:(id)arg2;
- (void)connectionDidFinishLoading:(id)arg1;
- (void)connection:(id)arg1 didReceiveData:(id)arg2;
- (void)connection:(id)arg1 didReceiveResponse:(id)arg2;
- (id)finalImage:(BOOL *)arg1;
- (id)progressImage:(BOOL)arg1;
- (double)resizesImageWithMaxNumberOfPixels;
- (BOOL)isConcurrent;
- (void)setExecuting:(BOOL)arg1;
- (void)setFinished:(BOOL)arg1;
- (void)connectionDidStart;
- (void)reloadConnection;
@end

NS_ASSUME_NONNULL_END

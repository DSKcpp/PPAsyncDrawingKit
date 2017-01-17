//
//  PPImageLoadRequest.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/24.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPImageLoadRequest : NSObject
@property (nullable, nonatomic, strong) NSError *error;
@property (nullable, nonatomic, strong) NSData *data;
@property (nullable, nonatomic, strong) UIImage *image;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nullable, nonatomic, copy) PPInternalCompletionBlock completedBlock;
@property (nullable, nonatomic, copy) PPWebImageDownloaderProgressBlock progressBlock;

- (instancetype)initWithURL:(NSString *)URL;
- (void)didReceiveDataSize:(int64_t)dataSize expectedSize:(int64_t)expectedSize;
- (NSInteger)retryCount;
- (void)start;
- (BOOL)finished;
- (BOOL)failed;
- (void)cancel;
- (void)retry;
- (void)requestDidFinish;
- (void)requestDidCancel;
@end

NS_ASSUME_NONNULL_END

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
@property (nonatomic, assign) BOOL isPermenant;
@property (nonatomic, assign) BOOL cancelForOwnerDealloc;
@property (nonatomic, assign) CGFloat minNotifiProgressInterval;
@property (nonatomic, weak) id owner;
@property (nullable, nonatomic, strong) NSError *error;
@property (nullable, nonatomic, strong) NSData *data;
@property (nullable, nonatomic, strong) UIImage *image;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy) PPImageLoadCompleteBlock completedBlock;
@property (nullable, nonatomic, copy) PPImageLoadProgressBlock progressBlock;
@property (nonatomic, assign) float progress;

- (instancetype)initWithURL:(NSString *)URL;
- (void)didReceiveDataSize:(NSUInteger)dataSize expectedSize:(NSUInteger)expectedSize;
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

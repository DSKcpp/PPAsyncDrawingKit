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

@interface PPImageLoadRequest : NSObject
@property(nonatomic) BOOL isPermenant;
@property(nonatomic) BOOL cancelForOwnerDealloc;
@property(nonatomic) CGFloat minNotifiProgressInterval;
@property(nonatomic) long long options;
@property(nonatomic, weak) id owner;
@property(nonatomic) long long storageType;
@property(retain, nonatomic) NSArray *alternativeUrls;
@property(retain, nonatomic) NSError *error;
@property(retain, nonatomic) NSData *data;
@property(retain, nonatomic) UIImage *image;
@property(nonatomic, copy, readonly) NSString *imageURL;
@property(nonatomic, copy) PPImageLoadCompleteBlock completedBlock;
@property(nonatomic, copy) PPImageLoadProgressBlock progressBlock;
@property(nonatomic) float progress;
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

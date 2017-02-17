//
//  PPTextAttachment.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PPAsyncDrawingKit/PPTextFontMetrics.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTextAttachment : NSObject
@property (nonatomic, copy) NSString *replacementText;
@property (nonatomic, strong) PPTextFontMetrics *baselineFontMetrics;
@property (nonatomic, strong) UIImage *contents;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) UIViewContentMode contentType;
@property (nonatomic, assign, readonly) CGSize placeholderSize;

+ (PPTextAttachment *)attachmentWithContents:(UIImage *)contents contentType:(UIViewContentMode)contentType contentSize:(CGSize)contentSize;

- (CGFloat)ascentForLayout;
- (CGFloat)descentForLayout;
- (CGFloat)leadingForLayout;

@end

NS_ASSUME_NONNULL_END

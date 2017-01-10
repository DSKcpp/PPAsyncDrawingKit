//
//  PPTextAttributes.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/10.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const PPTextHighlightRangeAttributeName;
UIKIT_EXTERN NSString * const PPTextBorderAttributeName;
UIKIT_EXTERN NSString * const PPTextAttachmentAttributeName;

@interface PPTextBorder : NSObject
@property (nonnull, nonatomic, strong) UIColor *fillColor;
@end

@interface PPTextHighlightRange : NSObject
@property (nullable, nonatomic, strong) NSMutableDictionary<NSString *, id> *attributes;
@property (nonatomic, assign) NSRange range;
@property (nullable, nonatomic, strong) NSDictionary<NSString *, id> *userInfo;
- (void)setTextColor:(nullable UIColor *)textColor;
- (void)setFont:(nullable UIFont *)font;
- (void)setBorder:(nullable PPTextBorder *)border;
@end

NS_ASSUME_NONNULL_END

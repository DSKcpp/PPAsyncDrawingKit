//
//  PPTextHighlightRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/6.
//  Copyright © 2016年 DSKcpp. All rights reserved.
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
- (void)setTextColor:(nullable UIColor *)textColor;
- (void)setFont:(nullable UIFont *)font;
- (void)setBorder:(nullable PPTextBorder *)border;
@end

NS_ASSUME_NONNULL_END

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
@property (nullable, nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@interface PPTextHighlightRange : NSObject
@property (nonatomic, assign) NSRange range;
@property (nullable, nonatomic, strong) NSDictionary<NSString *, id> *userInfo;
@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIFont *font;
@property (nullable, nonatomic, strong) PPTextBorder *border;
@end

@interface PPTextBackground : NSObject
@property (nullable, nonatomic, strong) NSDictionary<NSString *, id> *userInfo;
@property (nullable, nonatomic, strong) UIColor *backgroundColor;
@end

NS_ASSUME_NONNULL_END

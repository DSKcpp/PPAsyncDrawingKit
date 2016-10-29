//
//  PPTextAttachment.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPAsyncDrawingKitUtilities.h"

@interface PPTextAttachment : NSObject <NSCoding>
@property(nonatomic, copy) NSString *replacementText;
@property(nonatomic, assign) PPFontMetrics baselineFontMetrics;
@property(nonatomic, strong) id contents;
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, assign) UIViewContentMode contentType;
@property(readonly, nonatomic, copy) NSString *replacementTextForLength;
@property(readonly, nonatomic, copy) NSString *replacementTextForCopy;
@property(readonly, nonatomic, assign) PPFontMetrics fontMetricsForLayout;
@property(readonly, nonatomic, assign) CGSize placeholderSize;

+ (instancetype)attachmentWithContents:(id)contents type:(UIViewContentMode)type contentSize:(CGSize)contentSize;
- (void)updateContentEdgeInsetsWithTargetPlaceholderSize:(CGSize)placeholderSize;

- (CGFloat)leadingForLayout;
- (CGFloat)descentForLayout;
- (CGFloat)ascentForLayout;
@end

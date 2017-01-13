//
//  PPTextRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PPTextPosition;

@interface PPTextRange : UITextRange
@property (nonatomic, strong, readonly) PPTextPosition *start;
@property (nonatomic, strong, readonly) PPTextPosition *end;

- (instancetype)initWithRange:(NSRange)range;
- (NSRange)range;
@end

@interface PPTextPosition : UITextPosition
@property (nonatomic, assign, readonly) NSUInteger index;

+ (PPTextPosition *)textPositionWithIndex:(NSUInteger)index;
- (instancetype)initWithIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END

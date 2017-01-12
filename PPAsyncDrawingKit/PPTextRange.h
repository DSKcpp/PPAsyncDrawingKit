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
@property (nonatomic, strong) PPTextPosition *start;
@property (nonatomic, strong) PPTextPosition *end;
- (NSRange)range;
@end

@interface PPTextPosition : UITextPosition
@property (nonatomic, assign, readonly) NSUInteger index;
@end

NS_ASSUME_NONNULL_END

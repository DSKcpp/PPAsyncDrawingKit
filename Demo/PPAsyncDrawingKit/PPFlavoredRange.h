//
//  PPFlavoredRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/28.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPTextActiveRange <NSObject>
@property (nonatomic, strong) id userInfo;
@property (nonatomic, copy, readonly) NSString *keyRangeText;
@property (nonatomic, assign, readonly) NSRange keyRange;
@property (nonatomic, copy, readonly) NSString *rangeText;
@property (nonatomic, assign, readonly) NSInteger flavor;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, copy, readonly) NSString *text;

@optional
@property (nonatomic, strong) id dataBinding;
@end

@interface PPFlavoredRange : NSObject <PPTextActiveRange>
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSInteger flavor;
+ (PPFlavoredRange *)valueWithRange:(NSRange)range;
@end

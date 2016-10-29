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
@property (readonly, nonatomic, copy) NSString *keyRangeText;
@property (readonly, nonatomic, assign) NSRange keyRange;
@property (readonly, nonatomic, copy) NSString *rangeText;
@property (readonly, nonatomic, assign) NSInteger flavor;
@property (readonly, nonatomic, assign) NSRange range;
@property (readonly, nonatomic, copy) NSString *text;

@optional
@property(nonatomic, strong) id dataBinding;
@end

@interface PPFlavoredRange : NSObject <PPTextActiveRange>
+ (PPFlavoredRange *)valueWithRange:(NSRange)range;

@end

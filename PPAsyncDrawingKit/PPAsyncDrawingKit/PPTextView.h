//
//  PPTextView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/15.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <PPAsyncDrawingKit/PPAsyncDrawingView.h>
#import <PPAsyncDrawingKit/PPTextLayout.h>
#import <PPAsyncDrawingKit/NSAttributedString+PPExtendedAttributedString.h>

@class PPTextHighlightRange;
@class PPTextView;

NS_ASSUME_NONNULL_BEGIN

@interface PPTextView : PPAsyncDrawingView
@property (nonatomic, strong) PPTextLayout *textLayout;
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, weak) id<PPTextEventDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END

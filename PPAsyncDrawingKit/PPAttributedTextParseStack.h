//
//  PPAttributedTextParseStack.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAttributedTextRange.h"

@interface PPAttributedTextParseStack : NSObject
@property (nonatomic, strong) PPAttributedTextRange *firstEmotionRange;
@property (nonatomic, strong) PPAttributedTextRange *firstDollartagRange;
@property (nonatomic, strong) PPAttributedTextRange *firstHashtagRange;
@property (nonatomic, strong) NSMutableArray<PPAttributedTextRange *> *ranges;

- (PPAttributedTextRange *)parsingRange;
- (void)push:(PPAttributedTextRange *)range;
- (PPAttributedTextRange *)pop;
- (PPAttributedTextRange *)popToMode:(PPAttributedTextRangeMode)model;

@end

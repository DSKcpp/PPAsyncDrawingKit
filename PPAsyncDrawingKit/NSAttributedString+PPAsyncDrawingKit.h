//
//  NSAttributedString+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAsyncDrawingKitUtilities.h"

@class PPTextRenderer;

@interface NSAttributedString (PPAsyncDrawingKit)
+ (nullable PPTextRenderer *)rendererForCurrentThread;
+ (nullable PPTextRenderer *)pp_sharedTextRenderer;
- (nullable PPTextRenderer *)pp_sharedTextRenderer;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount;
- (CGSize)pp_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger)derivedLineCount baselineMetrics:(PPFontMetrics)baselineMetrics;
@end

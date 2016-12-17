//
//  PPIsomerismTextView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPAsyncDrawingView.h"
#import "PPTextRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPIsomerismTextView : PPAsyncDrawingView

@property (nullable, nonatomic, strong) NSArray<PPTextRenderer *> *textRenderers;
@property (nullable, nonatomic, strong) PPTextRenderer *respondTextRenderer;

- (nullable PPTextRenderer *)rendererAtPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END

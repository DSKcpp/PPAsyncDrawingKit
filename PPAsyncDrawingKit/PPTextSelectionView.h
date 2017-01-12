//
//  PPTextSelectionView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTextSelectionView : UIView

@end

@interface PPTextSelectionGrabber : UIView

@end

@interface PPTextCaretView : UIView
@property (nonatomic, assign, getter=isBlinking) BOOL blinking;
@end

NS_ASSUME_NONNULL_END

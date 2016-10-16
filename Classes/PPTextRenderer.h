//
//  PPTextRenderer.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTextLayout.h"

@protocol PPTextRendererDelegate <NSObject>

@end

@protocol PPTextRendererEventDelegate <NSObject>

@end

@interface PPTextRenderer : UIResponder
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) BOOL heightSensitiveLayout;
@property (nonatomic, weak) id <PPTextRendererDelegate> renderDelegate;
@property (nonatomic, weak) id <PPTextRendererEventDelegate> eventDelegate;
@property (nonatomic, weak) id <PPTextLayoutDelegate> layoutDelegate;
//@property (nonatomic, strong) id <WBTextActiveRange> savedPressingActiveRange;
//@property (retain, nonatomic) id <WBTextActiveRange> pressingActiveRange;
@property (nonatomic) struct CGPoint drawingOrigin;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) UIOffset shadowOffset;
@property (retain, nonatomic) UIColor *shadowColor;
@property (nonatomic, strong) PPTextLayout *textLayout;
- (UIOffset)drawingOffsetWithTextLayout:(PPTextLayout *)textLayout layoutFrame:(id)arg2;
- (void)drawHighlightedBackgroundForActiveRange:(id)arg1 rect:(struct CGRect)arg2 context:(struct CGContext *)arg3;
- (void)drawAttachmentsWithAttributedString:(id)arg1 layoutFrame:(id)arg2 context:(struct CGContext *)arg3 shouldInterrupt:(id)arg4;
- (void)drawInContext:(struct CGContext *)arg1 visibleRect:(struct CGRect)arg2 placeAttachments:(_Bool)arg3 shouldInterruptBlock:(id)arg4;
- (void)drawInContext:(struct CGContext *)arg1 shouldInterruptBlock:(id)arg2;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)draw;
@end

//
//  PPTextParagraphStyle.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@class PPTextParagraphStyle;

@protocol PPTextParagraphStyleDelegate <NSObject>
- (void)pp_paragraphStyleDidUpdateAttribute:(PPTextParagraphStyle *)TextParagraphStyle;
@end

@interface PPTextParagraphStyle : NSObject
@property (nonatomic, class, readonly) PPTextParagraphStyle *defaultParagraphStyle;
@property(nonatomic, assign) CGFloat paragraphSpacingAfter;
@property(nonatomic, assign) CGFloat paragraphSpacingBefore;
@property(nonatomic, assign) NSTextAlignment alignment;
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;
@property(nonatomic, assign) CGFloat maximumLineHeight;
@property(nonatomic, assign) CGFloat lineSpacing;
@property(nonatomic, assign) BOOL allowsDynamicLineSpacing;
@property(nonatomic, weak) id <PPTextParagraphStyleDelegate> delegate;
@property (nonatomic, assign) BOOL isNeedChangeSpace;

- (void)propertyUpdated;
- (CTParagraphStyleRef)newCTParagraphStyleWithFontSize:(NSInteger)fontSize;
- (NSMutableParagraphStyle *)nsParagraphStyleWithFontSize:(NSInteger)fontSize;
@end

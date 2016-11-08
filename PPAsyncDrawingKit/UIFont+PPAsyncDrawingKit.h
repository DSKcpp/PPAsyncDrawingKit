//
//  UIFont+PPAsyncDrawingKit.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/8.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (PPAsyncDrawingKit)
+ (void)pp_createFontDescriptors;
+ (instancetype)pp_fontWithCTFont:(CTFontRef)CTFont;
+ (CTFontDescriptorRef)pp_newFontDescriptorForName:(NSString *)name;
+ (CTFontRef)pp_newCTFontWithName:(NSString *)name size:(CGFloat)size;
+ (CTFontRef)pp_newCTFontWithCTFont:(CTFontRef)CTFont symbolicTraits:(NSUInteger)symbolicTraits;
+ (CTFontRef)pp_newItalicCTFontForCTFont:(CTFontRef)CTFont;
+ (CTFontRef)pp_newBoldCTFontForCTFont:(CTFontRef)CTFont;
+ (CTFontRef)pp_newBoldSystemCTFontOfSize:(CGFloat)size;
+ (CTFontRef)pp_newSystemCTFontOfSize:(CGFloat)size;
@end

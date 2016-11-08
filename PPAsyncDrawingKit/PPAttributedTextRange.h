//
//  PPAttributedTextRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/7.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PPAttributedTextRangeMode) {
    PPAttributedTextRangeModeNormal,
    PPAttributedTextRangeModeMention,
    PPAttributedTextRangeModeLink,
    PPAttributedTextRangeModeHashtag,
    PPAttributedTextRangeModeDollartag,
    PPAttributedTextRangeModeEmoticon,
    PPAttributedTextRangeModeDictation,
    PPAttributedTextRangeModeMiniCard,
    PPAttributedTextRangeModeEmailAdress
};

@interface PPAttributedTextRange : NSObject
@property (nonatomic, retain) id contentAttachment;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) NSUInteger location;
@property (nonatomic, assign) PPAttributedTextRangeMode mode;

+ (instancetype)rangeWithMode:(PPAttributedTextRangeMode)mode andLocation:(NSUInteger)locaiton;
@end


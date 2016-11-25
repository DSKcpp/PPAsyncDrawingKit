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

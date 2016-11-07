//
//  PPAttributedTextRange.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/7.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PPAttributedTextRangeModel) {
    PPAttributedTextRangeModelNormal,
    PPAttributedTextRangeModelMention,
    PPAttributedTextRangeModelLink,
    PPAttributedTextRangeModelHashtag,
    PPAttributedTextRangeModelDollartag,
    PPAttributedTextRangeModelEmoticon,
    PPAttributedTextRangeModelDictation,
    PPAttributedTextRangeModelMiniCard,
    PPAttributedTextRangeModelEmailAdress
};

@interface PPAttributedTextRange : NSObject
@property (nonatomic, retain) id contentAttachment;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) NSUInteger location;
@property (nonatomic, assign) PPAttributedTextRangeModel mode;

+ (instancetype)rangeWithMode:(PPAttributedTextRangeModel)mode andLocation:(NSUInteger)locaiton;
@end


//
//  PPTextStorage.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class PPTextStorage;

@protocol PPTextStorageDelegate <NSObject>
- (void)pp_textStorage:(PPTextStorage *)textStorage didProcessEditing:(NSUInteger)arg2 range:(NSRange)range changeInLength:(NSInteger)length;
@end

@interface PPTextStorage : NSMutableAttributedString
@property(nonatomic, weak) id <PPTextStorageDelegate> delegate;
- (NSString *)string;
@end

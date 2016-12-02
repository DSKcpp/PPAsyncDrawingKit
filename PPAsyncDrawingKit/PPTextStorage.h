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

typedef NS_OPTIONS(NSUInteger, PPTextStorageEditActions) {
    PPTextStorageEditedAttributes = (1 << 0),
    PPTextStorageEditedCharacters = (1 << 1)
};

NS_ASSUME_NONNULL_BEGIN

@protocol PPTextStorageDelegate <NSObject>
- (void)textStorage:(PPTextStorage *)textStorage
  didProcessEditing:(PPTextStorageEditActions)editedMask
              range:(NSRange)editedRange
     changeInLength:(NSInteger)delta;
@end

@interface PPTextStorage : NSMutableAttributedString
@property (nonatomic, weak) id <PPTextStorageDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

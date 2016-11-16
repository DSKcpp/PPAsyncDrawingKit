//
//  WBTimelineContentImageViewLayouter.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/16.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBTimelineContentImageViewLayouter : NSObject
@property (nonatomic, assign) CGRect layoutFrame;
@property (nonatomic, assign) BOOL needRelayout;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, strong) NSMutableDictionary *imageRowLayouters;
@property (nonatomic, assign) UIEdgeInsets layoutContentInsets;
@property (nonatomic, assign) CGFloat verticalSpacing;
@property (nonatomic, assign) CGFloat horizonSpacing;
@property (nonatomic, assign) CGFloat constraintWidth;
- (CGRect)_convertLayouterRect:(CGRect)arg1 fromLayouterColumn:(NSUInteger)arg2;
- (CGRect)contentView:(id)arg1 imageFrameForRow:(NSUInteger)row column:(NSUInteger)column;
- (NSUInteger)contentView:(id)arg1 numberOfColumnsInRow:(NSUInteger)row;
- (NSUInteger)numberOfGridImagesRowsIn:(id)arg1;
- (void)beginLayoutWithImageCount:(NSUInteger)arg1 block:(void(^)(void))arg2;
- (CGSize)sizeOfImageViewWithImages:(id)arg1 withImageViewClass:(Class)arg2;
@end

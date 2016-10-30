//
//  PPTextLayout.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayout.h"
#import <objc/objc-sync.h>

@implementation PPTextLayout
{
    struct {
        unsigned int needsLayout: 1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
//        self.baselineFontMetrics =
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
{
    if (self = [self init]) {
        self.attributedString = attributedString;
    }
    return self;
}

- (id)createLayoutFrame
{
    if (self.attributedString) {
        if (self.exclusionPaths.count != 0) {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectZero];
            [self.exclusionPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
            }];
        }
    } else {
        return nil;
    }
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        objc_sync_enter(self);
        _attributedString = attributedString;
        objc_sync_exit(self);
        flags.needsLayout = 1;
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        flags.needsLayout = 1;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        flags.needsLayout = 1;
    }
}

- (CGFloat)layoutHeight
{
    return self.layoutSize.height;
}

- (CGSize)layoutSize
{
    if (self.layoutFrame) {
        return self.layoutFrame.layoutSize;
    } else {
        return CGSizeZero;
    }
}
@end

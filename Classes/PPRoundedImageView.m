//
//  PPRoundedImageView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/9/22.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPRoundedImageView.h"

@implementation PPRoundedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _roundedCorners = 0;
        _showsCornerRadius = 1;
        self.userInteractionEnabled = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        _borderWidth = 0;
        self.clipsToBounds = YES;
        _updatePathWhenViewSizeChanges = YES;
        [self setDrawingPolicy:1];
        _useUIImageView = NO;
        _imageLayer = [CALayer layer];
        [self.layer addSublayer:_imageLayer];
        _isNeedChangeContentModel = NO;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _useUIImageView = YES;
    if (_image == image) {

    } else {
        [self setContentsChangedAfterLastAsyncDrawing:YES];
        if ([image isKindOfClass:[NSData class]]) {
            UIImage *dataImage = [UIImage imageWithData:(NSData *)image];
        } else {
            
        }
        _image = image;
        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)displayLayer:(CALayer *)layer
{
    if (_useUIImageView) {
        if (_isNeedChangeContentModel) {
            if (_imageLayer.contents != (id)_image.CGImage) {
                _imageLayer.contents = (__bridge id _Nullable)(_image.CGImage);
            }
        } else {
            _imageLayer.contents = nil;
            if (self.layer.contents != (id)_image.CGImage) {
                self.layer.contents = (__bridge id _Nullable)_image.CGImage;
            }
        }
    } else {
        [super displayLayer:layer];
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)async userInfo:(id)userInfo
{
    return YES;
}

@end

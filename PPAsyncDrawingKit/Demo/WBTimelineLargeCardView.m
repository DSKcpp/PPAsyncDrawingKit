//
//  WBTimelineLargeCardView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/9.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineLargeCardView.h"
#import "WBHelper.h"
#import "UIImage+Color.h"
#import "NSAttributedString+PPAsyncDrawingKit.h"

@implementation WBTimelineLargeCardView

+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    return [[pageInfo timelineModelViewClass] sizeConstraintToWidth:width forPageInfo:pageInfo displayType:type];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageWithColor:[UIColor colorWithRed:0.968f green:0.968f blue:0.968f alpha:1.0f]];
        _backgroundImageView.highlightedImage = [UIImage imageWithColor:[UIColor colorWithRed:0.941f green:0.941f blue:0.941f alpha:1.0f]];
        _backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:_backgroundImageView];
    }
    return self;
}

- (void)setPageInfo:(WBTimelinePageInfo *)pageInfo
{
    self.hidden = !pageInfo;
    _pageInfo = pageInfo;
    if (!_cardView) {
        Class cls = [pageInfo timelineModelViewClass];
        WBPageInfoBaseCardView *card = [[cls alloc] init];
        card.frame = self.bounds;
        _cardView = card;
        [self addSubview:_cardView];
    }
    _cardView.pageInfo = pageInfo;
    _backgroundImageView.frame = self.bounds;
}

@end

@implementation WBPageInfoBaseCardView
+ (CGSize)sizeConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    CGFloat height = [[self class] heightConstraintToWidth:width forPageInfo:pageInfo displayType:type];
    return CGSizeMake(width, height);
}

+ (CGFloat)heightConstraintToWidth:(CGFloat)width forPageInfo:(WBTimelinePageInfo *)pageInfo displayType:(NSInteger)type
{
    return 64.0f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat w = [WBTimelinePreset sharedInstance].maxWidth;
        _textView = [[WBTimelineLargeCardTextView alloc] initWithFrame:CGRectMake(80, 0, w - 90, 70)];
        [self addSubview:_textView];
        
        _imageView = [[PPWebImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setPageInfo:(WBTimelinePageInfo *)pageInfo
{
    _pageInfo = pageInfo;
    _textView.pageInfo = pageInfo;
    [_imageView setImageURL:[NSURL URLWithString:pageInfo.page_pic] placeholderImage:[UIImage imageNamed:@"avatar"]];
}
@end

@implementation WBTimelineLargeCardTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleTextLayout = [[PPTextLayout alloc] init];
        _titleTextLayout.numberOfLines = 1;
        [self addTextLayout:_titleTextLayout];
        
        _descTextLayout = [[PPTextLayout alloc] init];
        _descTextLayout.numberOfLines = 1;
        [self addTextLayout:_descTextLayout];
    }
    return self;
}

- (void)setPageInfo:(WBTimelinePageInfo *)pageInfo
{
    _pageInfo = pageInfo;
    [self setNeedsDisplay];
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    CGFloat w = self.frame.size.width;
    CGFloat y = 0;
    
    NSMutableAttributedString *title;
    CGFloat titleH = 0;
    NSString *titleText;
    if (_pageInfo.type == 2) {
        titleText = _pageInfo.content1;
    } else {
        titleText = _pageInfo.page_title;
    }
    if (titleText) {
        title = [[NSMutableAttributedString alloc] initWithString:titleText];
        [title pp_setFont:[UIFont systemFontOfSize:17.0f]];
        [title pp_setColor:[UIColor blackColor]];
        titleH = [title pp_sizeConstrainedToWidth:w numberOfLines:1].height;
        y = titleH + 5;
    }
    
    NSMutableAttributedString *desc;
    CGFloat descH = 0;
    NSString *descText;
    if (_pageInfo.type == 2) {
        descText = _pageInfo.content2;
    } else {
        descText = _pageInfo.page_desc;
    }
    if (descText) {
        desc = [[NSMutableAttributedString alloc] initWithString:descText];
        [desc pp_setFont:[UIFont systemFontOfSize:12.0f]];
        [desc pp_setColor:[UIColor blackColor]];
        descH = [desc pp_sizeConstrainedToWidth:w numberOfLines:1].height;
        y += descH;
        
    }
    
    CGFloat titleY = (self.frame.size.height - y) / 2.0f;
    if (title) {
        _titleTextLayout.frame = CGRectMake(0, titleY, w, titleH);
        _titleTextLayout.attributedString = title;
        [_titleTextLayout.textRenderer drawInContext:context];
    }
    
    if (desc) {
        _descTextLayout.frame = CGRectMake(0, y, w, descH);
        _descTextLayout.attributedString = desc;
        [_descTextLayout.textRenderer drawInContext:context];
    }
    return YES;
}
@end

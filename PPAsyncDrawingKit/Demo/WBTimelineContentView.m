//
//  WBTimelineContentView.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/11/10.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineContentView.h"
#import "UIView+Frame.h"
#import "UIImage+Color.h"
#import "WBHelper.h"
#import "NSString+PPAsyncDrawingKit.h"
#import "NSAttributedString+PPExtendedAttributedString.h"
#import "PPImageView+SDWebImage.h"
#import "NSNumber+Formatter.h"

@implementation WBColorImageView

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self setBackgroundColor:backgroundColor boolOwn:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor boolOwn:(BOOL)boolOwn
{
    [super setBackgroundColor:backgroundColor];
    if (boolOwn) {
        self.commonBackgroundColor = backgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (!self.image) {
        if (highlighted) {
            [self setBackgroundColor:self.highLightBackgroundColor boolOwn:NO];
        } else {
            [self setBackgroundColor:self.commonBackgroundColor boolOwn:NO];
        }
    }
}
@end

@interface WBTimelineContentView () <WBTimelineTextContentViewDelegate>
@end

@implementation WBTimelineContentView
{
    struct {
        BOOL trackingQuotedItemBorder;
        BOOL trackingTitleBorder;
    } _flags;
}

+ (CGFloat)heightOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width
{
    WBTimelineTableViewCellDrawingContext *context = [self validDrawingContextOfTimelineItem:timelineItem withContentWidth:width];
    return context.rowHeight;
}

+ (void)calculateContentHeightForDrawingContext:(WBTimelineTableViewCellDrawingContext *)drawingContext
{
    [WBTimelineTextContentView renderDrawingContext:drawingContext];
    drawingContext.rowHeight = drawingContext.contentHeight;
}

+ (WBTimelineTableViewCellDrawingContext *)validDrawingContextOfTimelineItem:(WBTimelineItem *)timelineItem withContentWidth:(CGFloat)width
{
    if (!timelineItem.drawingContext) {
        WBTimelineTableViewCellDrawingContext *drawingContext = [[WBTimelineTableViewCellDrawingContext alloc] initWithTimelineItem:timelineItem];
        drawingContext.contentWidth = width;
        [self calculateContentHeightForDrawingContext:drawingContext];
        timelineItem.drawingContext = drawingContext;
    }
    return timelineItem.drawingContext;
}

- (instancetype)initWithWidth:(CGFloat)width
{
    if (self = [self initWithFrame:CGRectMake(0, 0, width, 0)]) {
        self.contentWidth = width;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [self createTitleBgImageView];
    [self createTitleIcon];
    [self createItemContentBgImageView];
    [self createItemContentBackgroundView];
    [self createTextContentView];
    [self createNicknameLabel];
    [self createAvatarView];
    [self createActionButtonsView];
    [self createPhotoImageView];
}

- (void)createTitleBgImageView
{
    _titleBgImageView = [[WBColorImageView alloc] init];
    _titleBgImageView.userInteractionEnabled = YES;
    [_titleBgImageView setBackgroundColor:[UIColor whiteColor] boolOwn:YES];
    [self addSubview:_titleBgImageView];
}

- (void)createTitleIcon
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    _titleIcon = [[PPImageView alloc] initWithFrame:CGRectMake(preset.titleIconLeft, preset.titleIconTop, preset.titleIconSize, preset.titleIconSize)];
    [self addSubview:_titleIcon];
}

- (void)createItemContentBgImageView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5f)];
    topLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5f)];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _itemContentBgImageView = [[WBColorImageView alloc] init];
    _itemContentBgImageView.userInteractionEnabled = YES;
    [_itemContentBgImageView setBackgroundColor:[UIColor whiteColor]];
    _itemContentBgImageView.highLightBackgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    _itemContentBgImageView.topLineView = topLineView;
    _itemContentBgImageView.bottomLineView = bottomLineView;
    [_itemContentBgImageView addSubview:topLineView];
    [_itemContentBgImageView addSubview:bottomLineView];
    [self addSubview:_itemContentBgImageView];
}

- (void)createItemContentBackgroundView
{
    _quotedItemBorderButton = [[UIButton alloc] init];
    [_quotedItemBorderButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]] forState:UIControlStateNormal];
    [_quotedItemBorderButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]] forState:UIControlStateHighlighted];
    [_quotedItemBorderButton addTarget:self action:@selector(tapQouted:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_quotedItemBorderButton];
}

- (void)createNicknameLabel
{
    _nameLabel = [[WBNameLabel alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedNameLabel:)];
    [_nameLabel addGestureRecognizer:tap];
//    [_nameLabel addTarget:self action:@selector(selectedNameLabel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameLabel];
}

- (void)createTextContentView
{
    _textContentView = [[WBTimelineTextContentView alloc] init];
    _textContentView.delegate = self;
    [self addSubview:_textContentView];
}

- (void)createAvatarView
{
    WBTimelinePreset *preset = [WBTimelinePreset sharedInstance];
    _avatarView = [[PPImageView alloc] initWithFrame:CGRectMake(preset.leftSpacing, 0, preset.avatarSize, preset.avatarSize)];
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.cornerRadius = preset.avatarCornerRadius;
    _avatarView.borderColor = [UIColor blackColor];
    _avatarView.borderWidth = 0.1f;
    _avatarView.userInteractionEnabled = YES;
    [_avatarView addTarget:self action:@selector(selectedAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_avatarView];
}

- (void)createActionButtonsView
{
    CGFloat height = [WBTimelinePreset sharedInstance].actionButtonsHeight;
    _actionButtonsView = [[WBTimelineActionButtonsView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    [self addSubview:_actionButtonsView];
}

- (void)createPhotoImageView
{
    _photoImageView = [[WBTimelineImageContentView alloc] init];
    [self addSubview:_photoImageView];
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    if (_timelineItem != timelineItem) {
        _timelineItem = timelineItem;
        
        WBTimelineTableViewCellDrawingContext *drawingContext = timelineItem.drawingContext;
        
        self.frame = CGRectMake(0, 10, self.frame.size.width, drawingContext.contentHeight);
        
        self.titleBgImageView.frame = drawingContext.titleBackgroundViewFrame;
        
        self.nameLabel.user = timelineItem.user;
        self.nameLabel.frame = drawingContext.nicknameFrame;
        
        self.textContentView.drawingContext = drawingContext;
        self.textContentView.frame = CGRectMake(0, 0, drawingContext.contentWidth, drawingContext.contentHeight);
        
        self.itemContentBgImageView.frame = drawingContext.textContentBackgroundViewFrame;
        self.itemContentBgImageView.bottomLineView.bottom = self.itemContentBgImageView.height;
        
        self.actionButtonsView.bottom = drawingContext.contentHeight;
        self.actionButtonsView.frame = drawingContext.actionButtonsViewFrame;
        
        self.photoImageView.frame = drawingContext.photoFrame;
        if (drawingContext.hasQuoted) {
            self.photoImageView.pictures = timelineItem.retweeted_status.pic_infos.allValues;
        } else {
            self.photoImageView.pictures = timelineItem.pic_infos.allValues;
        }
        
        if (drawingContext.hasTitle) {
            self.titleIcon.hidden = !drawingContext.hasTitleICON;
            [self.titleIcon setImageURL:[WBHelper defaultURLForImageURL:_timelineItem.title.icon_url]];
        }
        
        self.avatarView.frame = drawingContext.avatarFrame;
        
        self.quotedItemBorderButton.frame = drawingContext.quotedContentBackgroundViewFrame;
        
        [self.avatarView setImageURL:[NSURL URLWithString:timelineItem.user.avatar_large] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        [self.actionButtonsView setTimelineItem:timelineItem];
    }
}

- (void)selectedAvatar:(PPImageView *)avarar
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didSelectedAvatarView:)]) {
        [_delegate tableViewCell:_cell didSelectedAvatarView:_timelineItem.user];
    }
}

- (void)selectedNameLabel:(UITapGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didSelectedNameLabel:)]) {
        [_delegate tableViewCell:_cell didSelectedNameLabel:_timelineItem.user];
    }
}

- (void)tapQouted:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didSelectedStatus:)]) {
        [_delegate tableViewCell:_cell didSelectedStatus:_timelineItem.retweeted_status];
    }
}

#pragma mark - WBTimelineContentView Delegate
- (void)textContentView:(WBTimelineTextContentView *)textContentView didPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didPressHighlightRange:)]) {
        [_delegate tableViewCell:_cell didPressHighlightRange:highlightRange];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        [self setSelectionColor:highlighted];
        [_quotedItemBorderButton setHighlighted:highlighted];
        [self setNeedsDisplay];
    }
}

- (void)setSelectionColor:(BOOL)highlighted
{
    [_itemContentBgImageView setHighlighted:highlighted];
    [_titleBgImageView setHighlighted:highlighted];
    [_textContentView setHighlighted:highlighted];
    [_avatarView setHighlighted:highlighted];
    [_actionButtonsView setButtonsHighlighted:highlighted];
    [_quotedItemBorderButton setHighlighted:highlighted];
}

- (BOOL)touchesInside:(NSSet<UITouch *> *)touches rect:(CGRect)rect
{
    UITouch *touch = touches.anyObject;
    CGPoint location = CGPointZero;
    if (touch) {
        location = [touch locationInView:self];
    }
    return CGRectContainsPoint(rect, location);
}

- (BOOL)touchesInsideTitleBorder:(NSSet<UITouch *> *)touches
{
    CGRect rect = self.timelineItem.drawingContext.titleBackgroundViewFrame;
    return [self touchesInside:touches rect:rect];
}

- (BOOL)touchesInsideActionButtonsArea:(NSSet<UITouch *> *)touches
{
    CGRect rect = self.timelineItem.drawingContext.actionButtonsViewFrame;
    return [self touchesInside:touches rect:rect];
}

- (BOOL)touchesInsideQuotedItemBorder:(NSSet<UITouch *> *)touches
{
    CGRect rect = self.timelineItem.drawingContext.quotedContentBackgroundViewFrame;
    return [self touchesInside:touches rect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self touchesInsideQuotedItemBorder:touches]) {
        _flags.trackingQuotedItemBorder = YES;
        self.quotedItemBorderButton.highlighted = YES;
    } else if ([self touchesInsideTitleBorder:touches]) {
        _flags.trackingTitleBorder = YES;
        self.titleBgImageView.highlighted = YES;
    } else if (![self touchesInsideActionButtonsArea:touches]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_flags.trackingQuotedItemBorder) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self touchesInsideQuotedItemBorder:touches]) {
                [self.quotedItemBorderButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            _flags.trackingQuotedItemBorder = NO;
            self.quotedItemBorderButton.highlighted = NO;
        });
    } else if (_flags.trackingTitleBorder) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self touchesInsideTitleBorder:touches]) {
//                [self.itemTypeBgImageView sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            _flags.trackingTitleBorder = NO;
            self.titleBgImageView.highlighted = NO;
        });
    } else {
        [super touchesEnded:touches withEvent:event];
        if ([_delegate respondsToSelector:@selector(tableViewCell:didSelectedStatus:)]) {
            [_delegate tableViewCell:_cell didSelectedStatus:_timelineItem];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_flags.trackingQuotedItemBorder) {
        self.quotedItemBorderButton.highlighted = NO;
        _flags.trackingQuotedItemBorder = NO;
    } else if (_flags.trackingTitleBorder) {
        self.titleBgImageView.highlighted = NO;
        _flags.trackingTitleBorder = NO;
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end

@interface WBTimelineActionButtonsView ()
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation WBTimelineActionButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initActionButtons];
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)initActionButtons
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3.0f;
    CGFloat height = [WBTimelinePreset sharedInstance].actionButtonsHeight;
    
    UIColor *titleColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    UIColor *bgColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    _retweetButton = [[PPButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_retweetButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_retweetButton setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
    [_retweetButton setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateHighlighted];
    _retweetButton.titleFont = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_retweetButton];
    
    _commentButton = [[PPButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [_commentButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateHighlighted];
    _commentButton.titleFont = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_commentButton];
    
    _likeButton = [[PPButton alloc] initWithFrame:CGRectMake(width * 2.0f, 0, width, height)];
    [_likeButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
    [_likeButton setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateHighlighted];
    _likeButton.titleFont = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_likeButton];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
        imageView.highlightedImage = [UIImage imageNamed:@"timeline_card_bottom_line_highlighted"];
        imageView.frame = CGRectMake((i + 1) * width, 0, 0.5f, [WBTimelinePreset sharedInstance].actionButtonsHeight);
        [self addSubview:imageView];
    }
}

- (void)setTimelineItem:(WBTimelineItem *)timelineItem
{
    NSString *retweetCount;
    if (timelineItem.reposts_count > 0) {
        retweetCount = [@(timelineItem.reposts_count) formatterCountToString];
    } else {
        retweetCount = @"转发";
    }
    [_retweetButton setTitle:retweetCount forState:UIControlStateNormal];
    
    NSString *commentCount;
    if (timelineItem.comments_count > 0) {
        commentCount = [@(timelineItem.comments_count) formatterCountToString];
    } else {
        commentCount = @"评论";
    }
    [_commentButton setTitle:commentCount forState:UIControlStateNormal];
    
    NSString *likeCount;
    if (timelineItem.attitudes_count > 0) {
        likeCount = [@(timelineItem.attitudes_count) formatterCountToString];
    } else {
        likeCount = @"赞" ;
    }
    [_likeButton setTitle:likeCount forState:UIControlStateNormal];
}

- (void)setButtonsHighlighted:(BOOL)highlighted
{
    _retweetButton.highlighted = highlighted;
    _commentButton.highlighted = highlighted;
    _likeButton.highlighted = highlighted;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.bottomLine.frame = CGRectMake(0, frame.size.height - 0.5f, self.width, 0.5f);
}

@end

@implementation WBNameLabel
- (void)setUser:(WBUser *)user
{
    if (_user != user) {
        _user = user;
        self.textLayout.numberOfLines = 1;
        self.attributedString = user.nameAttributedString;
    }
}

@end

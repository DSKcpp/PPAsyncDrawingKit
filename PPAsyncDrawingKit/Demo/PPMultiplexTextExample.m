//
//  PPMultiplexTextExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/19.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPMultiplexTextExample.h"
#import "PPMultiplexTextView.h"
#import "PPImageView.h"
#import "UIView+Frame.h"
#import "NSAttributedString+PPExtendedAttributedString.h"
#import "UIColor+HexString.h"

@interface PPMultiplexTextExample ()
@property (nonatomic, strong) PPMultiplexTextView *textView;
@end

@implementation PPMultiplexTextExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TextView
    _textView = [[PPMultiplexTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 0)];
    [self.view addSubview:_textView];
    
    // Avatar
    PPImageView *avatarImageView = [[PPImageView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 40, 40)];
    avatarImageView.image = [UIImage imageNamed:@"avatar"];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_textView addSubview:avatarImageView];
    
    CGFloat maxWidth = self.view.width - 80.0f;
    CGFloat totalHeight = 20.0f;
    
    // Name
    NSMutableAttributedString *nameAttrStr = [[NSMutableAttributedString alloc] initWithString:@"DSKcpp"];
    [nameAttrStr pp_setFont:[UIFont systemFontOfSize:16.0f]];
    [nameAttrStr pp_setColor:[UIColor colorWithHexString:@"596D95"]];
    
    PPTextHighlightRange *nameHighlight = [[PPTextHighlightRange alloc] init];
    PPTextBorder *nameBorder = [[PPTextBorder alloc] init];
    nameBorder.fillColor = [UIColor lightGrayColor];
    nameBorder.cornerRadius = 0;
    nameHighlight.border = nameBorder;
    [nameAttrStr pp_setTextHighlightRange:nameHighlight];
    
    CGSize nameSize = [nameAttrStr pp_sizeConstrainedToWidth:maxWidth numberOfLines:1];
    CGRect nameFrame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10.0f, totalHeight, nameSize.width, nameSize.height);
    
    PPTextLayout *nameTextLayout = [[PPTextLayout alloc] initWithAttributedString:nameAttrStr];
    nameTextLayout.numberOfLines = 1;
    nameTextLayout.frame = nameFrame;
    [_textView addTextLayout:nameTextLayout];
    
    totalHeight += nameSize.height;
    
    // Content
    NSMutableAttributedString *contentAttrStr = [[NSMutableAttributedString alloc] initWithString:@"iPhone 7 的出现，让 iPhone 的体验在许多重大方面都有了质的飞跃。它带来了先进的新摄像头系统、更胜以往的性能和电池续航力、富有沉浸感的立体声扬声器、色彩更明亮丰富的 iPhone 显示屏，以及防溅抗水的特性1。它周身的每一处，都闪耀着强大科技的光芒。这，就是 iPhone 7。"];
    [contentAttrStr pp_setFont:[UIFont systemFontOfSize:16.0f]];
    
    CGSize contentSize = [contentAttrStr pp_sizeConstrainedToWidth:maxWidth];
    CGRect contentFrame = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(nameFrame) + 5.0f, contentSize.width, contentSize.height);
    
    PPTextLayout *contentTextLayout = [[PPTextLayout alloc] initWithAttributedString:contentAttrStr];
    PPTextBackground *contentBackground = [[PPTextBackground alloc] init];
    contentBackground.backgroundColor = [UIColor colorWithHexString:@"C7C7C5"];
    contentTextLayout.highlighttextBackground = contentBackground;
    contentTextLayout.frame = contentFrame;
    [_textView addTextLayout:contentTextLayout];
    
    totalHeight += contentSize.height + 5.0f;
    
    // Time
    NSMutableAttributedString *timeAttrStr = [[NSMutableAttributedString alloc] initWithString:@"2小时前"];
    [timeAttrStr pp_setFont:[UIFont systemFontOfSize:12.0f]];
    [timeAttrStr pp_setColor:[UIColor lightGrayColor]];
    
    CGSize timeSize = [timeAttrStr pp_sizeConstrainedToWidth:maxWidth];
    CGRect timeFrame = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(contentFrame) + 5.0f, timeSize.width, timeSize.height);
    
    PPTextLayout *timeTextLayout = [[PPTextLayout alloc] initWithAttributedString:timeAttrStr];
    timeTextLayout.frame = timeFrame;
    [_textView addTextLayout:timeTextLayout];
    
    totalHeight += timeSize.height + 5.0f;
    
    // Comment
    NSMutableAttributedString *commentAttrStr = [[NSMutableAttributedString alloc] initWithString:@"Tim 厨师: 老铁双击666!"];
    [commentAttrStr pp_setFont:[UIFont systemFontOfSize:14.0f]];
    [commentAttrStr pp_setColor:[UIColor colorWithHexString:@"596D95"] inRange:NSMakeRange(0, 6)];
    
    PPTextHighlightRange *commentHignlight = [[PPTextHighlightRange alloc] init];
    PPTextBorder *commentBorder = [[PPTextBorder alloc] init];
    commentBorder.fillColor = [UIColor lightGrayColor];
    commentBorder.cornerRadius = 0;
    commentHignlight.border = commentBorder;
    [commentAttrStr pp_setTextHighlightRange:commentHignlight inRange:NSMakeRange(0, 6)];
    
    CGSize commentSize = [commentAttrStr pp_sizeConstrainedToWidth:maxWidth];
    CGRect commentFrame = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(timeFrame) + 5.0f, self.view.width - 70.0f, commentSize.height);
    
    PPTextLayout *commentTextLayout = [[PPTextLayout alloc] initWithAttributedString:commentAttrStr];
    PPTextBackground *commentBackground = [[PPTextBackground alloc] init];
    commentBackground.backgroundColor = [UIColor colorWithHexString:@"CCD2DE"];
    commentTextLayout.highlighttextBackground = commentBackground;
    commentTextLayout.frame = commentFrame;
    [_textView addTextLayout:commentTextLayout];
    
    totalHeight += commentSize.height + 5.0f;
    
    // Comment 1
    NSMutableAttributedString *comment1AttrStr = [[NSMutableAttributedString alloc]initWithString:@"Apple Inc: 引得起火热目光，更经得起水花洗礼。"];
    [comment1AttrStr pp_setFont:[UIFont systemFontOfSize:14.0f]];
    [comment1AttrStr pp_setColor:[UIColor colorWithHexString:@"596D95"] inRange:NSMakeRange(0, 9)];
    
    PPTextHighlightRange *comment1Hignlight = [[PPTextHighlightRange alloc] init];
    PPTextBorder *comment1Border = [[PPTextBorder alloc] init];
    comment1Border.fillColor = [UIColor lightGrayColor];
    comment1Border.cornerRadius = 0;
    comment1Hignlight.border = comment1Border;
    [comment1AttrStr pp_setTextHighlightRange:comment1Hignlight inRange:NSMakeRange(0, 9)];
    
    CGSize comment1Size = [comment1AttrStr pp_sizeConstrainedToWidth:maxWidth];
    CGRect comment1Frame = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(commentFrame) + 5.0f, self.view.width - 70.0f, comment1Size.height);
    
    PPTextLayout *comment1TextLayout = [[PPTextLayout alloc] initWithAttributedString:comment1AttrStr];
    PPTextBackground *comment1Background = [[PPTextBackground alloc] init];
    comment1Background.backgroundColor = [UIColor colorWithHexString:@"CCD2DE"];
    comment1TextLayout.highlighttextBackground = comment1Background;
    comment1TextLayout.frame = comment1Frame;
    [_textView addTextLayout:comment1TextLayout];
    
    totalHeight += comment1Size.height;
    
    totalHeight += 10.0f;
    _textView.height = totalHeight;
    
    // Comment background view
    UIView *commentBGView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMinY(commentFrame) + 64.0f, self.view.width - 70.0f, commentSize.height + 5.0f + comment1Size.height)];
    commentBGView.backgroundColor = [UIColor colorWithHexString:@"F3F3FF"];
    [self.view insertSubview:commentBGView atIndex:0];
}

@end

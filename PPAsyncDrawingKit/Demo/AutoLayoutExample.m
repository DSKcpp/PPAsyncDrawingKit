//
//  AutoLayoutExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/18.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "AutoLayoutExample.h"
#import <PPAsyncDrawingKit/PPAsyncDrawingKit.h>
#import "UIView+Constraint.h"
#import "UIImage+Color.h"

@interface AutoLayoutExample ()
@property (nonatomic, strong) PPImageView *avatarImageView;
@property (nonatomic, strong) PPTextView *nameLabel;
@property (nonatomic, strong) PPButton *followButton;
@end

@implementation AutoLayoutExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _avatarImageView = [[PPImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_avatarImageView];
    
    _nameLabel = [[PPTextView alloc] init];
    NSMutableAttributedString *nameAttrStr = [[NSMutableAttributedString alloc] initWithString:@"@DSKcpp"];
    [nameAttrStr pp_setFont:[UIFont systemFontOfSize:18.0f]];
    [nameAttrStr pp_setColor:[UIColor blackColor]];
    CGSize size = [nameAttrStr pp_sizeConstrainedToWidth:self.view.frame.size.width];
    _nameLabel.attributedString = nameAttrStr;
    [self.view addSubview:_nameLabel];
    
    _followButton = [[PPButton alloc] init];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [self.view addSubview:_followButton];
    
    [_avatarImageView pp_autoLayoutautoSetDimension:NSLayoutAttributeWidth toSize:50];
    [_avatarImageView pp_autoLayoutautoSetDimension:NSLayoutAttributeHeight toSize:50];
    [_avatarImageView pp_autoLayoutToSuperView:NSLayoutAttributeTop offset:100.0f];
    
    [_nameLabel pp_autoLayout:NSLayoutAttributeLeft toAttr2:NSLayoutAttributeRight toView:_avatarImageView offset:12.0f];
    [_nameLabel pp_autoLayout:NSLayoutAttributeTop toAttr2:NSLayoutAttributeTop toView:_avatarImageView];
    [_nameLabel pp_autoLayoutautoSetDimension:NSLayoutAttributeWidth toSize:size.width];
    [_nameLabel pp_autoLayoutautoSetDimension:NSLayoutAttributeHeight toSize:size.height];
    
    [_followButton pp_autoLayout:NSLayoutAttributeTop toAttr2:NSLayoutAttributeBottom toView:_nameLabel offset:12.0f];
    [_followButton pp_autoLayout:NSLayoutAttributeLeft toAttr2:NSLayoutAttributeLeft toView:_nameLabel];
    [_followButton pp_autoLayoutautoSetDimension:NSLayoutAttributeWidth toSize:60];
    [_followButton pp_autoLayoutautoSetDimension:NSLayoutAttributeHeight toSize:20];
}

@end

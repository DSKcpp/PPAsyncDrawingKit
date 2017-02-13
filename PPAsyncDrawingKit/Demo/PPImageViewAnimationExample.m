//
//  PPImageViewAnimationExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageViewAnimationExample.h"
#import "PPImageView.h"
#import "UIView+Frame.h"

@implementation PPImageViewAnimationExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PPImageView *imageView = [[PPImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    [imageView setImageURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/large/64eba0degw1fbaf4kaamag20a906z4qp.gif"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    [self.view addSubview:imageView];
}

@end

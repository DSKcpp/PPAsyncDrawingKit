//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "PPRoundedImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PPRoundedImageView *imageView = [[PPRoundedImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"avatar"];
    imageView.userInteractionEnabled = YES;
    [imageView addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
}

- (void)tapImageView:(PPRoundedImageView *)imageView
{
    NSLog(@"%@", imageView);
}

@end

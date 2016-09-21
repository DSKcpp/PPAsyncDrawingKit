//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "PPAsyncDrawingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PPAsyncDrawingView *view = [[PPAsyncDrawingView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:nil action:nil forControlEvents:0];
}

@end

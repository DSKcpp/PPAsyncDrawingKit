//
//  TextViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "TextViewController.h"
#import "PPLabel.h"
#import "PPTextAttributed.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PPLabel *label = [[PPLabel alloc] initWithFrame:CGRectMake(0, 128, self.view.frame.size.width, 200)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"#纽约漫展#  漫威副总带AC娘@陈一发儿  逛漫展！http:\\\\t.cn\\RVLYKtI 我们有幸还被邀请进入了漫威的Secret Room [哆啦A梦吃惊] #acfun#"];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.attributedString = attributedString;
    [self.view addSubview:label];
}


@end

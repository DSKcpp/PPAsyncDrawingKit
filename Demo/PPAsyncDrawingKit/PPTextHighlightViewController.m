//
//  PPTextHighlightViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/30.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextHighlightViewController.h"
#import "PPLabel.h"
#import "PPTextAttributed.h"

@interface PPTextHighlightViewController ()

@end

@implementation PPTextHighlightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Link"];
    [one pp_setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [one pp_setColor:[UIColor redColor]];
    CGFloat height = [one pp_heightConstrainedToWidth:CGRectGetWidth(self.view.bounds)];
    
    CGRect rect = CGRectZero;
    rect.origin.y = 104;
    rect.size = CGSizeMake(CGRectGetWidth(self.view.bounds), height);
    PPTextHighlightRange *highlight = [[PPTextHighlightRange alloc] init];
    [one pp_setTextHighlightRange:highlight];
    PPLabel *label = [[PPLabel alloc] initWithFrame:rect];
    label.attributedString = one;
    [self.view addSubview:label];
}

@end

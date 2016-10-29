//
//  TextViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "TextViewController.h"
#import "PPTextContentView.h"
#import "PPCoreTextInternalView.h"
#import "PPTextParagraphStyle.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PPCoreTextInternalView *coreTextView = [[PPCoreTextInternalView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    coreTextView.attributedString = [[NSAttributedString alloc] initWithString:@"A you ok?"];
    [self.view addSubview:coreTextView];
}


@end

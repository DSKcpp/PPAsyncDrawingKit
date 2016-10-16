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
@property (nonatomic, strong) PPTextContentView * textContentView;
@property (nonatomic, strong) PPCoreTextInternalView *coreTextView;
@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _textContentView = [[PPTextContentView alloc] init];
//    _textContentView.frame = self.view.bounds;
//    [self.view addSubview:_textContentView];
    _coreTextView = [[PPCoreTextInternalView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_coreTextView];
    
    NSLog(@"%@", [PPTextParagraphStyle defaultParagraphStyle]);
}


@end

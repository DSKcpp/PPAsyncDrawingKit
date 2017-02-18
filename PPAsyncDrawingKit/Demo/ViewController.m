//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "PPDemoToolBar.h"
#import "UIView+Frame.h"

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat height = 35.0f;
    PPDemoToolBar *toolBar = [[PPDemoToolBar alloc] initWithFrame:CGRectMake(0, self.view.bottom - height, self.view.width, height)];
    [[UIApplication sharedApplication].keyWindow addSubview:toolBar];
    
    self.tableViewItems = @[[ExampleItem t:@"Image View Example" c:@"PPImageExample"],
                            [ExampleItem t:@"Text View Example" c:@"PPTextExample"],
                            [ExampleItem t:@"Button Example" c:@"PPButtonExample"],
                            [ExampleItem t:@"AutoLayout Example" c:@"AutoLayoutExample"],
                            [ExampleItem t:@"Feeds List Example" c:@"WBTimelineViewController"]];
}

@end


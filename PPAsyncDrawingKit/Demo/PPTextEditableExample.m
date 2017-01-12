//
//  PPTextEditableExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/1/13.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPTextEditableExample.h"
#import "PPEditableTextView.h"

@interface PPTextEditableExample ()

@end

@implementation PPTextEditableExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PPEditableTextView *textView = [[PPEditableTextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
}


@end
